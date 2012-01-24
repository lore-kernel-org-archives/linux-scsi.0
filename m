From: "Loke, Chetan" <Chetan.Loke@netscout.com>
Subject: RE: [LSF/MM TOPIC] linux servers as a storage server - what'smissing?
Date: Tue, 24 Jan 2012 12:05:23 -0500
Message-ID: <D3F292ADF945FB49B35E96C94C2061B9159D00EC@nsmail.netscout.com>
References: <4EF2026F.2090506@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22B19@BLRX7MCDC203.AMER.DELL.COM> <20111222155849.GD1388@redhat.com> <DBFB1B45AF80394ABD1C807E9F28D157077DD22D79@BLRX7MCDC203.AMER.DELL.COM> <4F0ADB0A.9020707@suse.de> <1326113987.2580.8.camel@localhost.localdomain> <D3F292ADF945FB49B35E96C94C2061B9159134BD@nsmail.netscout.com> <4F18429C.3020803@redhat.com> <D3F292ADF945FB49B35E96C94C2061B9159134EF@nsmail.netscout.com> <4F1844F0.1030406@redhat.com> <D3F292ADF945FB49B35E96C94C2061B9159135BF@nsmail.netscout.com> <4F18566A.2060107@redhat.com> <D3F292ADF945FB49B35E96C94C2061B915913815@nsmail.netscout.com> <4F188DA9.3050804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod6og102.obsmtp.com ([64.18.1.183]:35228 "HELO
	exprod6og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756172Ab2AXRF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2012 12:05:26 -0500
Content-class: urn:content-classes:message
In-Reply-To: <4F188DA9.3050804@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Tom Coughlan <coughlan@redhat.com>, Hannes Reinecke <hare@suse.de>, tasleson@redhat.com, Shyam_Iyer@Dell.com, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org

> > But writes that have to fetch the non-cached data, will
unnecessarily
> > issue I/O to the fabric. These orphaned I/O's cause more pain in the
> > cleanup.
> > And if caching is enabled on the front-side then it's all the more
> > painful.
> >
> > We can go one extra step and make FS fail read I/O for non-cached
data
> > too to avoid more orphan IOs.
> 
> I don't really see this as a useful state. Read-only without a real
> backing file
> system or LUN is hit or miss, that file system should go offline :)
> 

Last year when I checked, I forget but I think xfs(or ext4) was going
read-only.
If this is still the case then you are basically asking FS's to modify
that behavior.
