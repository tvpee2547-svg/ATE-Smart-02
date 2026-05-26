import React, { useState } from 'react';
import { supabase } from '../main'; // 

function RepairPage() {
  const [text, setText] = useState('');
  const [imageFile, setImageFile] = useState(null);
  const [loading, setLoading] = useState(false);

  // ฟังก์ชันสแกนไฟล์ภาพเมื่อผู้ใช้เลือกรูป
  const handleFileChange = (e) => {
    if (e.target.files && e.target.files[0]) {
      setImageFile(e.target.files[0]);
    }
  };

  // 1. ฟังก์ชันอัปโหลดรูปขึ้น Supabase Storage
  const uploadImageToStorage = async (file) => {
    const fileExt = file.name.split('.').pop();
    const fileName = `repair-${Date.now()}.${fileExt}`; // ตั้งชื่อไฟล์ใหม่ป้องกันการซ้ำ

    const { data, error } = await supabase.storage
      .from('images') // ดึงจากชื่อ Bucket ที่สร้างไว้
      .upload(fileName, file);

    if (error) {
      console.error('Upload Error:', error.message);
      return null;
    }

    // ดึง Public URL ออกมาเมื่ออัปโหลดเสร็จ
    const { data: publicUrlData } = supabase.storage
      .from('images')
      .getPublicUrl(fileName);

    return publicUrlData.publicUrl;
  };

  // 2. ฟังก์ชันกดส่งข้อมูลฟอร์มทั้งหมด
  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!text) return alert('กรุณากรอกรายละเอียดแจ้งซ่อม');

    setLoading(true);
    let finalImageUrl = '';

    // ถ้ามีการเลือกรูปภาพ ให้เอาไปเข้ากระบวนการอัปโหลดก่อน
    if (imageFile) {
      finalImageUrl = await uploadImageToStorage(imageFile);
      if (!finalImageUrl) {
        setLoading(false);
        return alert('อัปโหลดรูปภาพล้มเหลว');
      }
    }

    // บันทึกตัวหนังสือพร้อมลิงก์ภาพตัวเต็มลงตาราง requests ในฐานข้อมูล
    const { error } = await supabase
      .from('requests')
      .insert([
        {
          text: text,
          image_url: finalImageUrl // บันทึกลิงก์ https://... ลงฐานข้อมูลเรียบร้อย
        }
      ]);

    setLoading(false);

    if (error) {
      alert('เกิดข้อผิดพลาด: ' + error.message);
    } else {
      alert('ส่งข้อมูลแจ้งซ่อมเรียบร้อยและภาพขึ้นระบบแล้ว!');
      setText('');
      setImageFile(null);
    }
  };

  return (
    <div className="max-w-md mx-auto mt-10 p-6 bg-white rounded-lg shadow-md text-black">
      <h2 className="text-2xl font-bold mb-6 text-center">ฟอร์มแจ้งซ่อมอุปกรณ์</h2>
      <form onSubmit={handleSubmit}>
        <div className="mb-4">
          <label className="block text-gray-700 mb-2">รายละเอียดข้อความปัญหาสิ่งของ</label>
          <textarea
            className="w-full p-2 border rounded"
            rows="3"
            placeholder="ตัวอย่าง: ห้อง405 ชั้น4 สาขาคอมพิวเตอร์"
            value={text}
            onChange={(e) => setText(e.target.value)}
          />
        </div>
        <div className="mb-4">
          <label className="block text-gray-700 mb-2">รูปภาพประกอบ</label>
          <input
            type="file"
            accept="image/*"
            onChange={handleFileChange}
            className="w-full"
          />
        </div>
        <button
          type="submit"
          disabled={loading}
          className="w-full bg-red-600 text-white p-2 rounded hover:bg-red-700 font-bold"
        >
          {loading ? 'กำลังส่งข้อมูล...' : 'ส่งข้อมูลแจ้งซ่อม'}
        </button>
      </form>
    </div>
  );
}

export default RepairPage;