From: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: PATCH: scsi-sd-last-sector-bug-flag.patch
Date: Sun, 20 Jan 2008 22:10:54 +0100
Message-ID: <4793B8DE.2050208@hhs.nl>
References: <47931E8A.60905@hhs.nl> <20080120205514.GA28842@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20080120205514.GA28842@kroah.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Greg KH <greg@kroah.com>
Cc: Guillaume Bedot <littletux@zarb.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-usb@vger.kernel.org, David Brown <usb-storage2@davidb.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

Greg KH wrote:
> On Sun, Jan 20, 2008 at 11:12:26AM +0100, Hans de Goede wrote:
>> Hi all,
>>
>> This patch adds a new scsi_device flag for devices which contain a bug 
>> where
>> the device crashes when the last sector is read in a larger then 1 sector 
>> read.
>>
>> This is for example the case with sdcards in the HP PSC1350 printer 
>> cardreader
>> and in the HP PSC1610 printer cardreader.
> 
> Wait, we already handle this in the usb-storage driver, why are you
> putting this in the scsi core now?
> 

No we don't, I've send patches for this to the usb-storage driver but they were 
refused as they modified scsi commands in flight, the consensus was that this 
should be done in the scsi layer, hence this patch.

> confused,

I've noticed, esp. with regards to your second mail to which I will reply next. 
There has been a lot of discussion about this ending in this (perfectly fine) 
patch, which is much better then my original hack if I may add that.

Regards,

Hans

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
