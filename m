From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating
 SMART/ATA-Security in usb-storage driver
Date: Fri, 4 Nov 2005 15:46:13 -0800
Message-ID: <20051104154613.189d5f43.zaitcev@redhat.com>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com>
Sender: linux-ide-owner@vger.kernel.org
To: Timothy Thelin <Timothy.Thelin@wdc.com>
Cc: mdharm-scsi@one-eyed-alien.net, James.Bottomley@SteelEye.com, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, zaitcev@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Fri, 4 Nov 2005 10:30:44 -0800, "Timothy Thelin" <Timothy.Thelin@wdc.com> wrote:

> The problem then is with vendor specific commands as SCSI core
> mangles those as well.  The vendor specific command I had issues
> with is the "ATACB" ATA passthru cdb that cypress boards understand.
> CDB[1] is a signature byte that must be 0x24.  Needless to say,
> that leading 2 gets masked off to a 0, and the drive aborts the
> ATACB.  Now cypress could have been smarter about designing their
> cdb, but they wern't, and so there really needs to be a way to tell
> SCSI core "hands off the cdb".

If this issue is real, you can use ub with that device for now.

-- Pete
