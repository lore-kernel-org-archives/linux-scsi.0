From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv4 1/1] SCSI: hosts: update to use ida_simple for host_no management
Date: Mon, 14 Dec 2015 20:55:04 -0500
Message-ID: <yq1r3iowk5j.fsf@sermon.lab.mkp.net>
References: <cover.1444241058.git.lduncan@suse.com>
	<f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>
	<1444830904.2220.28.camel@HansenPartnership.com>
	<561EA018.7020700@suse.com>
	<1444848835.2220.50.camel@HansenPartnership.com>
	<5644BEE1.3010208@suse.com> <yq1ziyhy38c.fsf@sermon.lab.mkp.net>
	<5649C79E.9070603@suse.de> <564A4EDC.8060805@suse.com>
	<yq1d1v8tdr3.fsf@sermon.lab.mkp.net> <5669F31C.2010409@suse.com>
	<1449847911.4067.200.camel@localhost.localdomain>
	<566DC3F0.6050206@suse.com>
	<1450105632.4091.17.camel@localhost.localdomain>
	<566EE055.9050708@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <566EE055.9050708@suse.de> (Hannes Reinecke's message of "Mon, 14
	Dec 2015 16:29:25 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, emilne@redhat.com, Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

>> I'm not opposed to having the module option if others (Martin?) feel
>> they need it, but generally I think it's better to keep things as
>> simple as possible.  So, unless there are strong objections, I would
>> say no.

Hannes> Agreeing with Ewan here.

Hannes> I guess it's up to you to tell us whether you absolutely need a
Hannes> module parameter ...

Still not a big ida fan but since the most people seem to be in favor of
this I guess I'll have to bite the bullet.

I don't see much value in the module parameter since it will require
customers to tweak their configs and reproduce. Not worth the hassle.

-- 
Martin K. Petersen	Oracle Linux Engineering
