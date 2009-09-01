From: Andrei Tanas <andrei@tanas.ca>
Subject: Re: MD/RAID time out writing superblock
Date: Tue, 01 Sep 2009 10:18:06 -0400
Message-ID: <419cca21f9440d50bf6c95716ffc5402@localhost>
References: <004e01ca25e4$c11a54e0$434efea0$@ca> <9cfb6af689a7010df166fdebb1ef516b.squirrel@neil.brown.name> <4A948A82.4080901@redhat.com> <b585ed9f13649050bbc984869d081315.squirrel@neil.brown.name> <4A94905F.7050705@redhat.com> <005101ca25f4$09006830$1b013890$@ca> <4A94A0E6.4020401@redhat.com> <005401ca25ff$9ac91cc0$d05b5640$@ca> <4A950FA6.4020408@redhat.com> <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BC033.9000909@pobox.com> <4A9C60A1.50303@rtr.ca> <640f6103c45b6cba6f84f887bde227e4@localhost> <4A9D1E7D.1050104@rtr.ca> <4A9D2204.1000608@kernel.org> <4A9D25F3.2030207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tanas.ca ([206.248.136.31]:60187 "EHLO tanas.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066AbZIAOSJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2009 10:18:09 -0400
In-Reply-To: <4A9D25F3.2030207@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Mark Lord <liml@rtr.ca>, Mark Lord <mlord@pobox.com>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>

On Tue, 01 Sep 2009 09:47:31 -0400, Ric Wheeler <rwheeler@redhat.com>
wrote:
>>>> Mine errored out again with exactly the same symptoms, this time after
>>>> only
>>>> few days and with the "tunable" set to 2 sec. I got a warranty
>>>> replacement
>>>> but haven't shipped this one yet. Let me know if you want it.
>>> ..
>>>
>>> Not me.  But perhaps Tejun ?
>>
>> I think you're much more qualified than me on the subject. :-)
>>
>> Anyone else?  Ric, are you interested with playing the drive?
> 
> No thanks....
> 
> I would suggest that Andrei install the new drive and watch it for a few
> days to 
> make sure that it does not fail in the same way. If it does, you might
want
> to look at the power supply/cables/etc?

The drive is the second member of RAID1 array, as far as I understand, both
drives should be experiencing very similar access patterns, and they are
the same model with the same firmware, and manufactured on the same day,
but only one of them showed these symptoms, so there must be something
"special" about it.
By now I think that MD made the right "decision" failing the drive and
removing it from the array, so I guess let's leave it at that.

Andrei.
