From: Mark Lobo <ntdeveloper2002@yahoo.com>
Subject: Bounce buffer usage
Date: Thu, 31 Oct 2002 16:16:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021101001632.48278.qmail@web80301.mail.yahoo.com>
References: <3DBF3E43.2000503@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DBF3E43.2000503@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Guys,
Simple question on bounce buffer usage.
As of my understanding right now, a bounce buffer will
not be used if 
1) We say we dont support over a fixed number of
address bits, for example, ISA devices.
2) If the address of the buffer is not in a space
directly addressable by the kernel ( not in kernel
logical address space )

Now my question is: what happens in the case where an
application sends an IO down? are bounce buffers used
in that case? I guess I am still confused on kernel
virtual v/s kernel logical addresses. As I understand,
a kernel logical address is one that is directly
addressable by the kernel, and is limited to 1GB. So
if we have a system with 2GB, does it mean some of the
physical memory ( probably 1GB )  has a kernel logical
address assigned to it permanently and the other 1GB
does not, which means if a user happens to get a page
in that space, there will be no logical address ( and
therefore bounce buffers WILL be used? ).
Or is any user address not mapped in the kernel
"logical" space at all? 

Im confused in this one, I would appreciate if someone
can clear it up for me.

Thanks,
Mark



__________________________________________________
Do you Yahoo!?
New DSL Internet Access from SBC & Yahoo!
http://sbc.yahoo.com
