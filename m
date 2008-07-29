From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 12:43:23 -0600
Message-ID: <660360F4F2570145BD872F298951B17A3AC7E3B3@cosmail03.lsi.com>
References: <488F524F.6020905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <488F524F.6020905@redhat.com>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: "rwheeler@redhat.com" <rwheeler@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Martin Petersen <mkp@mkp.net>
Cc: Jim Meyering <jim@meyering.net>
List-Id: linux-scsi@vger.kernel.org

Ric Wheeler wrote:
>     (1) R/W optical drives
>     (2) S390 dasd devices have a 4096 byte sector
>     (3) new 4096 byte disks (which intend to export a virtual 512 byte
> sector)
>

I was wondering about formatting drives with DIF support??  Martin told me he is using sg_format, however it doesn't support type 3 protection format, which has 6 byte application tag.

Eric
