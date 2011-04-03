From: Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: PMP and SEMB messages to SEP
Date: Sun, 3 Apr 2011 19:39:03 +0200
Message-ID: <20110403173903.GK25397@MAIL.13thfloor.at>
References: <20110114165957.GH16039@MAIL.13thfloor.at> <20110114170407.GE978@htj.dyndns.org> <20110114173759.GI16039@MAIL.13thfloor.at> <20110117154042.GG27123@htj.dyndns.org> <1295281131.3015.44.camel@mulgrave.site> <20110117171836.GI27123@htj.dyndns.org> <1295284906.3015.136.camel@mulgrave.site> <20110117172415.GK27123@htj.dyndns.org> <20110125030740.GB24024@MAIL.13thfloor.at> <1295964854.4955.21.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1295964854.4955.21.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2011 at 09:14:14AM -0500, James Bottomley wrote:
> On Tue, 2011-01-25 at 04:07 +0100, Herbert Poetzl wrote:
>> On Mon, Jan 17, 2011 at 06:24:15PM +0100, Tejun Heo wrote:
>>> On Mon, Jan 17, 2011 at 11:21:46AM -0600, James Bottomley wrote:
>>>> Expanders aren't SCSI devices either ... that means they don't
>>>> appear as visible to standard SCSI mechanisms like INQUIRY (SMP
>>>> isn't a SCSI protocol it's a SAS extension). They just appear as
>>>> part of the topology in the device tree.

>>> Ah, okay.  Then, things would be much simpler.  I was worrying about
>>> how it would map to SCSI layer including INQUIRY emulations and all
>>> those stuff.  Thanks for the info.

>> So, any thoughts on how and where to add the PMP to the devices
>> available for sending SCSI or ATA commands to?

>> I'm willing to try to add the required code, but I'm sure I'll
>> benefit from a few hints from the experts ...

> Well, I'm not sure I'd count as an expert on this piece:
> I haven't read the relevant ATA standards. 

> From what I understand, SES packets are encapsulated over 
> an ATA command for SEMB.

correct, just that it can be any protocol (it's just another
bus, usually i2c) with the common protocols being SES and
SAF_TE AFAIK

> In that case, it should be fairly simple to recognise
> this and present a SCSI device which simply encapsulates
> everything sent to it over this protocol. 

do you have any pointers for me how that is done for SCSI?

> That would allow the ses ULD to attach seamlessly.

any pointers to such an SES ULD (maybe for testing)?

thanks in advance,
Herbert

> James


> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
