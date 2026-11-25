Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795600817;
	b=mqmWOgmIIFWMSPR2P4Fl+CM5VIJCCTPSTfkO+RmwIWvX6XZzwVSBtJu1u1lBPlAabYGH
	 xfpOmYedOAtnVqn7/A3/IIzr2jrb4ZlP2Au/X9bMuJlhCbg/pKDaMIKgSk61jmU5FdBhQ
	 vfALYvrPGVWVe9hFYW5erD1AgZ/GGiaGa3xDzoii8J0advChhdz4lYfhmwCIhFGgJda7z
	 Kk5Oh44pe4Y9HtZU6jPnSejwQbI7cInML9ZOFTRK7zn7V53/GRI1S85Fala1PBrM1ZqtC
	 32BWm7Z9q7Ef72hKKKVM3gWkYGScv98J/OrM+oK4tjy/ZyykAxweyoUkLAOst418aqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795600817;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6Xv5qPmm0dHiJb1NJzGm83vzcGRgH+0sehHVb5Pqb2I=;
	b=WtHXht+UZcW0tq3Q6THZjpZeG3flxWZimLbIoJ7sM8RHEXXIqUKMf31OhdVYn2DxGaUH
	 P96JM2UGzsEio3aMlsbN4KZHSB4HeanPdl7P1tCdpG+AV0z4R0OxS0lRIXqc6oRwXON/3
	 /AcfrY36qkgpVOd8+QSral/O8bpNSlWyMWJdA/IOyB/swZB4mj049Cl7wc45LQCvSwVAE
	 alWs5L5SPZk/C+Q5qxjS7C6syQPuiLXXonRqnrJubsQQewj1cEAB8ay2Wu+grwq/Xysk0
	 Md/QfMYlDp3o8H8chCD3oYSyrWKfKhcBCeKqvhQUKRJkp0uYyhdjNto8fGUAdySJLKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DVUBozaW;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C243E606A332
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 10:00:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C243E606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DVUBozaW
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4aa5833c263so5327809f8f.2
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 02:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795600815; x=1796205615; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6Xv5qPmm0dHiJb1NJzGm83vzcGRgH+0sehHVb5Pqb2I=;
        b=DVUBozaWJibJ2qkUjBok/yqvhjSJTx8QOWPpK+7M0qjVq5JDGwhRKEX+cvC89A+0vK
         +A6ePP+hzNMrf/gdOxcJYkJqSU007bA3w8G3wmrkERcesCmx1/PkEG3ZfxM2OTO/lFY3
         Xplk3igbPc8N/FuxQMnxfblszKSIvU2Q4G3czZgmRZrVkOg5q5+IrF5pkR9an56936Pa
         wYfY3LnAz9L1IniJorLl0Vs+6MTyud5KuzivMG3Cr5qtolv7t2noU1s845Z0PWNU1Kcj
         PjR244NWb4eK3drUTi/xxmN6NJdtoeMCvigpDdaIled1h5QuZ55hhiQOzzgA7yp2O8Tw
         YgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795600815; x=1796205615;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6Xv5qPmm0dHiJb1NJzGm83vzcGRgH+0sehHVb5Pqb2I=;
        b=yIoky+fQDFs2Nvrc47A3pPYAJnOcJOPt7kYZrL3fr/soXQToQhi+c5gFxmHnM7MK18
         EtkZeyM96OGc/bOxoFo71FG5lmmNXJoFzW01cw2g7rALksDLem19oC+yd22qpx6wASVb
         KwbqUKuHz3QmitOSPBWvQF9Vhs87AqoU0NnAVozBECHNXR7zIwd0fkcF/w1m6FEcWcnc
         jV46dtRdP+8lADPsn9zDU+ayBldEWfT05bUUc0NMUc4gM71nRkkay0vZVEVd0Uqu1qVJ
         ImYnnzO4IqKnOsUlojuAr8ZPh431CTQsGlne/q8BBpkBzY6Z0CbpA0sT0UzwBd2FiNu4
         alrg==
X-Forwarded-Encrypted: i=1; AL+hErHulIVHVqh03LvT3Hy/T+XS+M+mHCn/be3hgHwbTHYYAAwfcwAgJ7GjlGu9ufMaRID2MnLnMw90af5q@vger.kernel.org
X-Gm-Message-State: APuU4Z8a8EObCvTo2R4xyvZ4yCJuLgUS6VJNE7miXna6UOh1kQmnIlL5
	Jf2sBsiwjbtvNb7Dr82j58olQcmPJD/XcNusdcK3BCbPFz9yjPoscSPK
X-Gm-Gg: AZFdTZfZjTTsIMk+1MB/rxcpvpjtvbmAo+8QSGTKNPTHJwJX0Pb2ARy0NyU7scb/Qpk
	Sh8ra20RmhRDwMYz4c8xQhsvW93J4pXC0ODcbHFk9LFWLthOY9XY4aycE/U+0H68/ssRJ8veUAq
	5C3cGrW7g3kTAGbeal6Ef+lfrvGNYQLXixSpebPA+N1Q97JTW37zn2oNMBMNF8UIzagYcApaTXE
	RWf1YmUW+pXCNrpMlrDejMjDYCmDWeXRNJ4f1dJB98JUJyGZQyipOl3b+fTuxFwFUD0oYnpTMa1
	YMPRuhvCKBb8c9ko4ty/N+VXTQycDWslIRBJ2IcIWErVK9QN6RX9mNjKvo/zMIqcVp0QcNOEUpz
	DK0fPkvmnFPegQGQYGOrYuzdpRDVGKRxwnFMkeIynvoTRgdggn3IAdeak+aPPd1rZKPdgp6cc2w
	08yPrSXJbjQP+uAb2Ib+1f7Y+Q7igFVz8W8eDu/PQw9CX8/K4g4BlFQDQHiyE0HXtpWCFuu7B+S
	oOS8kEnPUZy2lqjWiz5ljHCgKsyylQowcvI9Av6XqzN2mfNAUGe/kQD7MrwYjKctADteKswcw+H
	ixFhDVG12z+i6t+DbWxB8BHQPxmXxBqUpgrTGLciSFquxIEua3y8h9KpVphdYDOELQ==
X-Received: by 2002:a05:6000:454f:b0:48e:6419:ddf2 with SMTP id ffacd0b85a97d-4abb2168ec7mr22189006f8f.17.1795600814661;
        Wed, 25 Nov 2026 02:00:14 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ad644140b5sm30001376f8f.17.2026.11.25.02.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:00:14 -0800 (PST)
Date: Wed, 25 Nov 2026 10:00:13 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Finn Thain" <fthain@linux-m68k.org>, "Bart Van Assche"
 <bvanassche@acm.org>, "Geert Uytterhoeven" <geert@linux-m68k.org>, "kernel
 test robot" <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
 "Linux Memory Management List" <linux-mm@kvack.org>, "James E . J .
 Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
Message-ID: <20261125100013.356bc7c7@pumpkin>
In-Reply-To: <f0ec2845-245d-43ac-9c96-242e0d1d11ea@app.fastmail.com>
References: <20261121034304.2dPxVKzk-lkp@intel.com>
	<0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org>
	<CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
	<669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org>
	<8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
	<85e103fe-acca-0880-1be3-cb1e7f79f9a4@linux-m68k.org>
	<f0ec2845-245d-43ac-9c96-242e0d1d11ea@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 24 Nov 2026 11:18:19 +0100
"Arnd Bergmann" <arnd@arndb.de> wrote:

> On Tue, Nov 24, 2026, at 04:31, Finn Thain wrote:
> > On Mon, 23 Nov 2026, Bart Van Assche wrote:
> >  
> >> On 11/23/26 3:05 PM, Finn Thain wrote:  
> >> > Yes, two alternative solutions were submitted in March (either remove the
> >> > assertion or rework it). The build bot reported the problem again in
> >> > September so I resubmitted the "rework" alternative. Sashiko-bot didn't
> >> > have much praise for that*, so now I'm leaning towards the "remove"
> >> > alternative. I have been advised to keep re-submitting, and I will do so
> >> > after a suitable back-off in retry rate i.e. 2027 or 2028.
> >> > 
> >> > *
> >> > https://lore.kernel.org/r/93e35f60-e465-7f76-0043-f997fe2ec8c7@linux-m68k.org  
> >> 
> >> What an LLM came up with after I asked it to fix 
> >> https://lore.kernel.org/lkml/202603030747.VX0v4otS-lkp@intel.com/ can be 
> >> found below. One of the comments of the LLM is "This is essentially Finn 
> >> Thain's "Rework BUILD_BUG_ON() assertion" patch with your two review 
> >> comments from this morning applied". Sashiko reports "No issues found" 
> >> for the patch below. No Signed-off-by from me because I think Finn 
> >> should be credited for his work instead of I.
> >>   
> >
> > Thanks, Bart. I'll take that as a vote for "rework". There is an 
> > associated risk though: I can't test the patch as I don't have access to 
> > suitable hardware. (Perhaps someone with such access will volunteer.) 
> >
> > Whereas, the "remove" alternative doesn't require testing as it doesn't 
> > risk a regression.
> >
> > I have a question for your LLM. Sashiko-bot said, in response to my patch:
> >
> >     Similarly, get_datalen_for_atio() accesses the array out-of-bounds 
> >     when len > 0:
> >
> >     drivers/scsi/qla2xxx/qla_target.h:get_datalen_for_atio() {
> >     ...
> >         return get_unaligned_be32(&atio->u.isp24.fcp_cmnd.add_cdb[len * 4]);
> >     ...
> >     }
> >
> > I don't understand why the patch from your LLM did not raise the same OOB 
> > access concerns.  
> 
> I suspect that is just from Bart specifically calling it out in the changelog
> already as a known limitation "Do not modify the memcpy() call in
> qlt_queue_unknown_atio(), which still writes past the end of the 'atio'
> member.".
> 
> > Adding a flex array to struct qla_tgt_sess_op can prevent new struct 
> > members being added in the wrong spot in that struct but can't prevent new 
> > struct members being added to struct atio7_fcp_cmnd. Neither does the 
> > assertion. So the "remove" alternative doesn't have all the disadvantages 
> > that you might expect.  
> 
> This is probably just a difference in perception: atio_from_isp and
> everything inside is clearly marked as a hardware structure that is
> meant to align exactly to the 64 byte cacheline, so it would not
> make any sense to change its layout and add more members here.
> qla_tgt_sess_op on the other hand is clearly not a hardware structure
> but an in-kernel one, so it is quite unexpected that one of its members
> extends past the end, especially when the other three instances of
> atio_from_isp in data structures don't seem to do that.
> 
> >> @@ -227,7 +224,7 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
> >>   		add_cdb_len =
> >>   			((unsigned int) atio->u.isp24.fcp_cmnd.add_cdb_len) * 4;
> >> 
> >> -	u = kzalloc(sizeof(*u) + add_cdb_len, GFP_ATOMIC);
> >> +	u = kzalloc_flex(*u, extra_cdb, add_cdb_len, GFP_ATOMIC);
> >>   	if (u == NULL)
> >>  		goto out_term;  
> 
> While this does make the current implementation more correct by having
> the correct length, I'm worried that it just ends up establishing
> the complexity more in the sense that extra_cdb extends both into
> the padding and beyond qla_tgt_sess_op.

Isn't the struct also embedded in the middle of other structures
so can't end in a flex array?

> If the driver is still actively maintained, it would be nice to
> reduce the complexity instead, in one of two ways:
> 
> a) make atio_from_isp naturally aligned by dropping the bogus
>    __packed attribute, so it is actually at the end of qla_tgt_sess_op
>    as the driver was written to expect. Note that having the
>    outer structure as __packed but the union and the inner
>    structs as aligned is itself problematic and can lead to
>    undefined behavior, if some code ever takes a pointer to
>    one of the inner aggregates and expects it to be aligned.
>    The only effect that I see from the __packed annotation is
>    that it forces expensive byte access on dma-coherent memory
>    despite it being fully aligned.

It looks to me like almost all of the __packed in that header
are bogus - there is one on an le64 member which could easily
be on an odd 32bit boundary.
What it really wants is an 'error if any padding' flag.
(And maybe a compile-time check on the longer structures.)

If the hardware does dma onto those structures then you really
don't want them misaligned either.

Bag of worms :-)

David

> 
> b) rework the driver more broadly to never actually do any
>    accesses beyond a struct boundary and make it work with
>    sanitizers enabled. One way to do this would be to
>    have a separate isp24 atio structure that is not in the
>    union but that encloses the actual maximum length.
>    Not sure how this would actually be done, but it appears
>    that the current design keeps causing problems, see e.g.
>    091719c21d5a ("scsi: qla2xxx: target: Fix invalid memory
>    access with big CDBs") which adds more complexity around
>    keeping an extra copy for it.
> 
>       Arnd
> 

