From: Andy Grover <agrover@redhat.com>
Subject: old linux scsi headers
Date: Fri, 09 Jan 2015 09:38:50 -0800
Message-ID: <54B0122A.9050509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-56168-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: libc-alpha@sourceware.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hello glibc people,

This concerns sysdeps/unix/sysv/linux/scsi/{scsi, scsi_ioctl, sg}.h

They define common SCSI values, as well as Linux's SCSI-related ioctls.

Apparently they were copied from the Linux kernel tree back in 1999, so 
they're pretty stale.

I'm wondering if I should submit a patch to update these to what's 
current from the Linux tree, or if maybe it wouldn't be better to have 
users just directly get these as "uapi" headers from the Linux kernel 
source directly?

The latter method has issues with being a breaking change for code that 
relies on what's in glibc now, which may or may not be something we can 
ease, but would ensure the headers would not become stale again in the 
future.

What do you think about the best way to proceed?

Thanks -- Regards -- Andy
