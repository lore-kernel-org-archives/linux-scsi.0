From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 14:41:47 -0400
Message-ID: <yq17ib4r0r8.fsf@sermon.lab.mkp.net>
References: <488F524F.6020905@redhat.com>
	<20080729182611.GB24924@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080729182611.GB24924@parisc-linux.org> (Matthew Wilcox's message of "Tue\, 29 Jul 2008 12\:26\:11 -0600")
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Matt Domsch <Matt_Domsch@Dell.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> I'll admit to having not tested it with anything other than
Matthew> 512, but it ought to support 4096 byte sectors just fine.  I
Matthew> haven't looked at what would be required to support 520-byte
Matthew> sectors.

I recently added multiple sector support to scsi_debug.  On a recent
kernel you can modprobe scsi_debug sector_size=4096.

I have only tested 4KB but it also supports 1 and 2KB.

-- 
Martin K. Petersen	Oracle Linux Engineering

