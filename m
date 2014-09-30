From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 29/38] Introduce dev_printk_string() and dev_printk_header()
Date: Tue, 30 Sep 2014 07:48:13 +0200
Message-ID: <542A441D.7050606@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de> <1411991947-130166-30-git-send-email-hare@suse.de> <20140929165843.GA13163@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140929165843.GA13163@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/29/2014 06:58 PM, Greg Kroah-Hartman wrote:
> On Mon, Sep 29, 2014 at 01:58:58PM +0200, Hannes Reinecke wrote:
>> Introducing dev_printk_string() and dev_printk_header() to allow
>> using an external buffer for printing via dev_printk().
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: LKML <linux-kernel@vger.kernel.org>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/base/core.c    | 24 ++++++++++++++++++++++++
>>   include/linux/device.h | 12 ++++++++++++
>>   2 files changed, 36 insertions(+)
>
> I don't understand, what are you trying to do with this?  I don't see
> any follow-on patches that use this, nor can I find a 00/38 patch for
> this series...
>
Well, I've copied lkml only for the generic interface changes.
The main bulk of patches have been posted to linux-scsi.
But it seems I should have posted all of them to lkml, too.

As I'll have to redo the patchset anyway as Steven Rostedt isn't so sur=
e=20
about his seq_buf patches I'll be posting the next series to
both, lkml and linux-scsi.

Or do you prefer to keep the printk() patches as a separate patchset an=
d=20
have the scsi fixes on top of that?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
