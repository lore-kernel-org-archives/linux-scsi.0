From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Sat, 27 Apr 2013 08:03:21 +0200
Message-ID: <517B6A29.7040406@redhat.com>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike> <5177BF53.3040305@redhat.com> <5177CAF5.6060506@suse.de> <5177CB23.5090802@redhat.com> <5177CFB6.9070105@redhat.com> <5177D6C2.6080705@redhat.com> <5177EDB5.5000105@tributary.com> <8D3D17ACE214DC429325B2B98F3AE71293F3BBE2@MX15A.corp.emc.com> <5178438F.3010103@gmail.com> <1366837373.1971.28.camel@dabdike> <5178548D.6020805@redhat.com> <1366841383.1971.36.camel@dabdike> <yq17gjrv1h8.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:54337 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab3D0GDf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Apr 2013 02:03:35 -0400
Received: by mail-ea0-f181.google.com with SMTP id a11so1879403eae.26
        for <linux-scsi@vger.kernel.org>; Fri, 26 Apr 2013 23:03:33 -0700 (PDT)
In-Reply-To: <yq17gjrv1h8.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Ric Wheeler <ricwheeler@gmail.com>, "Black, David" <david.black@emc.com>, Jeremy Linton <jlinton@tributary.com>, Ric Wheeler <rwheeler@redhat.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Knight, Frederick" <Frederick.Knight@netapp.com>

Il 25/04/2013 03:32, Martin K. Petersen ha scritto:
> I'm ok with your patch. And a strong believer in not altering the
> SYNCHRONIZE CACHE behavior that's been rigorously tested in the field by
> adding SYNC_NV to the mix.

SYNC_NV is absolutely necessary for targets that (a) have both volatile
and non-volatile cache, and (b) actually follow the standards behavior
for SYNC_NV=0.

I used NV_SUP as a guess that the SYNC_NV bit is supported, perhaps
V_SUP && NV_SUP is a better guess.

Paolo
