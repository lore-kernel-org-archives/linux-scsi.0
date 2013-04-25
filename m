From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Thu, 25 Apr 2013 07:12:37 -0700
Message-ID: <1366899157.2232.1.camel@dabdike>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike>
	    <5177BF53.3040305@redhat.com> <5177CAF5.6060506@suse.de>
	    <5177CB23.5090802@redhat.com> <5177CFB6.9070105@redhat.com>
	    <5177D6C2.6080705@redhat.com> <5177EDB5.5000105@tributary.com>
	    <8D3D17ACE214DC429325B2B98F3AE71293F3BBE2@MX15A.corp.emc.com>
	    <5178438F.3010103@gmail.com> <1366837373.1971.28.camel@dabdike>
	   <5178548D.6020805@redhat.com> <1366841383.1971.36.camel@dabdike>
	  <51785E5C.8020204@redhat.com> <1366843580.1971.38.camel@dabdike>
	 <517914FA.4040106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60551 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753894Ab3DYOMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Apr 2013 10:12:39 -0400
In-Reply-To: <517914FA.4040106@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <ricwheeler@gmail.com>, "Black, David" <david.black@emc.com>, Jeremy Linton <jlinton@tributary.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Knight, Frederick" <Frederick.Knight@netapp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Thu, 2013-04-25 at 07:35 -0400, Ric Wheeler wrote:
> It was pointed out to me that RCD is "Read Cache Disable" so by
> setting it to 
> zero, we are enabling the read cache (not that we ever look at this
> bit or send 
> it down). The WCE bit is "write cache enable" so the polarity of the
> bits is 
> inverted.
> 
> Should be fine regardless :)

Just look at the code.  We already do the right thing.

The whole reason for combining both into cache policy is that half the
world got the individual bits wrong.  We translate from an
understandable cache policy to and from WCE/RCD speak.

James


