From: Kevin Tappe <kevintappe@gmx.de>
Subject: g_NCR5380.c:931: warning: `id_table' defined but not used
Date: Sun, 25 Apr 2004 10:49:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <408B7BB7.8000406@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:3288 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262961AbUDYIu3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Apr 2004 04:50:29 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

i get a warning compiling kernel 2.6.5:

  LD      drivers/scsi/sd_mod.o
  CC      drivers/scsi/sg.o
  LD      drivers/scsi/built-in.o
  CC [M]  drivers/scsi/g_NCR5380.o
drivers/scsi/g_NCR5380.c:931: warning: `id_table' defined but not used
  CC [M]  drivers/scsi/g_NCR5380_mmio.o
drivers/scsi/g_NCR5380.c:931: warning: `id_table' defined but not used

Compiler is:
/usr/src/linux$ gcc -v
Reading specs from /usr/lib/gcc-lib/i386-linux/2.95.4/specs
gcc version 2.95.4 20011002 (Debian prerelease)

-Kevin

