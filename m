From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: ADAPTEC 2.4 drivers too old
Date: Mon, 15 Mar 2004 10:30:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F64E534@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:3796 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262608AbUCOPan convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Mar 2004 10:30:43 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose@wanadoo.es>
Cc: arjanv@redhat.com, linux-scsi <linux-scsi@vger.kernel.org>

I would *hate* to point fingers until the root cause is completed for
all issues. But the Driver has yet to be the root cause of any of the
problems experienced by the Dell 2650 users. In each case where an
alternate driver is selected that appears to resolve the issue, it is a
detuned variant. Remember, most of the people solved their problems by
turning off Hyperthreading, or turning of the card's Cache.

The issues experienced by some of the 2650 owners have several causes.
One root cause has been hardware problems. For instance, where the PCI
bus no longer responds (traced to a faulty power supply), another was
traced to a bad hard drive locking up the SCSI bus, another issue was
addressed by a driver workaround for the Adapter Firmware being
overloaded during times of internal Cache Flush.

To add to the frustration, in none of the other peripheral cases have we
been able to duplicate the issue in-house (Dell or at Adaptec), which
generally means to me that the issue is hardware specific. Systems that
exhibited the problem have been shipped to the factory, only to stop
exhibiting the problem.

It certainly is not for a lack of trying ...

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Xose Vazquez
Perez
Sent: Saturday, March 13, 2004 2:17 PM
To: unlisted-recipients
Cc: arjanv@redhat.com; 'linux-scsi'
Subject: Re: ADAPTEC 2.4 drivers too old

Xose Vazquez Perez wrote:

> Arjan van de Ven wrote:
> 
>> I object to the words "too old" in your subject.
>> The reality is that 2.4 doesn't have the brand-spanking-newest driver
>> version *numbers*. So what? Newer != automatically better.
> 
> 
> http://marc.theaimsgroup.com/?l=linux-kernel&m=107456492323846&w=2
> 
> "... and left at least the aic79xx driver in a worse state than it
> was in before ..."
> 

there are more examples....

Do you call to aacraid stable driver ?

ask to Dell 2650 owners:
http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=92129
http://lists.us.dell.com/pipermail/linux-aacraid-devel/

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
