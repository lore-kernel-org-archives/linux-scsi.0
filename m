From: Lionel Elie Mamane <lionel@mamane.lu>
Subject: Re: PROBLEM: Linux 2.4.19 + aic7xxx driver = crash
Date: Wed, 9 Oct 2002 16:07:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021009140751.GC18381@home.mamane.lu>
References: <20021009133617.GA18381@home.mamane.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from master by tofu.home.mamane.lu with local (Exim 3.35 #1 (Debian))
	id 17zHV9-0005Ez-00
	for <linux-scsi@vger.kernel.org>; Wed, 09 Oct 2002 16:07:51 +0200
Content-Disposition: inline
In-Reply-To: <20021009133617.GA18381@home.mamane.lu>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, Oct 09, 2002 at 03:36:17PM +0200, Lionel Elie Mamane wrote:
> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

Forgot /proc/iomem, on tofu:

00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000cd7ff : Extension ROM
000e0000-000effff : Extension ROM
000f0000-000fffff : System ROM
00100000-0fffdbff : System RAM
  00100000-0023411e : Kernel code
  0023411f-002b891f : Kernel data
0fffdc00-0ffffbff : ACPI Tables
0ffffc00-0fffffff : ACPI Non-volatile Storage
d0000000-d0000fff : Adaptec AHA-3940U2x/395U2x
d0001000-d0001fff : Adaptec AHA-3940U2x/395U2x (#2)
d0002000-d000207f : 3Com Corporation 3c905B 100BaseTX [Cyclone]
d0100000-d1ffffff : PCI Bus #01
  d0100000-d0100fff : ATI Technologies Inc 3D Rage Pro AGP 1X/2X
  d1000000-d1ffffff : ATI Technologies Inc 3D Rage Pro AGP 1X/2X
e0000000-efffffff : Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX Host bridge
fffe7000-ffffffff : reserved

-- 
Lionel
