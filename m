From: Chris Friesen <chris_friesen@sympatico.ca>
Subject: unloading scsi debug module gives errors in logs
Date: Thu, 09 Oct 2003 21:35:46 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3F860CF2.8010105@sympatico.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com
List-Id: linux-scsi@vger.kernel.org


Seen on 2.6.0-test6:

Oct  9 21:22:25 doug kernel: SCSI device sda: 16384 512-byte hdwr 
sectors (8 MB)
Oct  9 21:22:25 doug kernel: SCSI device sda: drive cache: write back
Oct  9 21:22:25 doug kernel:  sda: unknown partition table
Oct  9 21:22:25 doug kernel: Attached scsi disk sda at scsi1, channel 0, 
id 0, lun 0
Oct  9 21:22:53 doug kernel: FAT: bogus number of reserved sectors
Oct  9 21:22:53 doug kernel: VFS: Can't find a valid FAT filesystem on 
dev sda.
Oct  9 21:24:42 doug kernel: Device 'pseudo_0' does not have a release() 
function, it is broken and must be fixed.
Oct  9 21:24:42 doug kernel: Badness in device_release at 
drivers/base/core.c:85
Oct  9 21:24:42 doug kernel: Call Trace:
Oct  9 21:24:42 doug kernel:  [device_release+68/80] 
device_release+0x44/0x50
Oct  9 21:24:42 doug kernel:  [kobject_cleanup+67/96] 
kobject_cleanup+0x43/0x60
Oct  9 21:24:42 doug kernel:  [kobject_put+20/32] kobject_put+0x14/0x20
Oct  9 21:24:42 doug kernel:  [put_device+13/32] put_device+0xd/0x20
Oct  9 21:24:42 doug kernel:  [device_unregister+17/32] 
device_unregister+0x11/0x20
Oct  9 21:24:42 doug kernel:  [__crc_generic_file_llseek+338540/1261671] 
scsi_debug_exit+0x3b/0x4b [scsi_debug]
Oct  9 21:24:42 doug kernel:  [sys_delete_module+301/336] 
sys_delete_module+0x12d/0x150
Oct  9 21:24:42 doug kernel:  [sys_munmap+55/96] sys_munmap+0x37/0x60
Oct  9 21:24:42 doug kernel:  [syscall_call+7/11] syscall_call+0x7/0xb
