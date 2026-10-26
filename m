Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793033241;
	b=ARKHDK08DcXryyXcQJB95BxKvAM/EzKr/Q0cI3hyaTOSJNIpXFaTjAvSI9BmsTlHu2Pr
	 TQlVFAgzTWzdtGh89IPqIEJqJYHhamrexQtCLZHx1MFRMoptGNX/vES+QY47vG0czSdIS
	 J5NNjQdAmFCerd5W5aEXZG/BU6O0etwzykG153fUEazZmv1iRqfSfH1gmtMZCzq+lVFlH
	 vMnuOnujEnGGidCG68rA2Dx5aqHM8EPBxFOukYFOK0wnaP6AcIRM0CeMdMtw4DZC59e0g
	 vFKwI4TO5wlK0lMzTRhMw/fGgpqJddRAtR7PWXn+v6Wpe3qXxtPsIUTm1UpKfOnIhDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793033241;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WS4isQQSroS3wWFqM94ABAKwJ1kET9HOrS0FpgyuMzI=;
	b=ZCLNBKbdUjLopN2dzQGwRLVQ7xShh42YDh04l6Z/nA7haxT46EKeBjM4sJOESBvDpmzs
	 Bg2PmXaXZtgoDwB8WLN3V8xzn9At45u5s7vbq8tNWEufu8kWkm3CxgFLpPtO/StpLvebf
	 IPE+hjOtndzQT4P7Fldk5UNt8ZQRtEhAFWFe0/WNOWZPrHEYwjHCr3nLhVoT2SwcpYfiY
	 vWW4TmIl8lcOwwiU5DjstNDLl1YjyTQtam1ypRADYw1yW5ThAhunftLOdpMGLNU/WPhfo
	 +AgdnedaMcAkTqBiXjcBRRY2viSPv2c9G0/wTGaroOkaP684/73GpRf6u3uoMC8NWbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b="D7P2/F7g";
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A581606A31D;
	Mon, 26 Oct 2026 16:47:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A581606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=D7P2/F7g
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jD00S5XbLz1XM30g;
	Mon, 26 Oct 2026 16:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793033237; x=1795625238; bh=WS4isQQSroS3wWFqM94ABAKw
	J1kET9HOrS0FpgyuMzI=; b=D7P2/F7gbOipDSF6pvCRMYDfmhdmYeJ990wqOfM2
	sT0jYBdgFPM/MdWniSb3/61CPxt6DLG0UjxPHBGiC3WBZte9T2ptCsemzH3zoF0Q
	qlVicmT0Syk6M9KWkkdiLy0+UXsbAh0tEWR4BHbfW085LU1L+CX8DfUBWuCyQQ53
	awngbD1AST0f3EoElQUO8x/ukVhS1MfLFvpxAMMoGRpWEdEcpTbJDK7ojewt6hlZ
	x7dQOvzokFuq6vnNlvCP5n1ToA+pJnXFxI1R8TfEMjpRIjvOB2oyYR028zE13xGJ
	5Jc2hNL/C6qcNGZnWb/l8UzbD4z5Dwk4UIn0XkPiz+7pwQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id D8zur16HWW2i; Mon, 26 Oct 2026 16:47:17 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jD00N6CdBz1XM4Tl;
	Mon, 26 Oct 2026 16:47:16 +0000 (UTC)
Message-ID: <ea77fa74-3290-4685-b1d7-24c45ca1286c@acm.org>
Date: Mon, 26 Oct 2026 09:47:15 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] scsi: target: iscsi: fix stalled and doubly
 completed aborted WRITEs
To: Laurence Oberman <loberman@redhat.com>, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 mlombard@redhat.com, michael.christie@oracle.com,
 linux-kernel@vger.kernel.org
References: <20261026150710.1063511-1-loberman@redhat.com>
 <79480408-8403-4a93-a2dc-c5f01864a20c@acm.org>
 <8d705915480f6cbe6a1b37c2cd06eb98727b3207.camel@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8d705915480f6cbe6a1b37c2cd06eb98727b3207.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/26 9:12 AM, Laurence Oberman wrote:
 > If the guard is one-shot across both, a second call that would have
 > taken the CMD_T_STOP branch is suppressed too, and I am not sure that
 > is safe -- a suppressed complete_all() could leave a waiter in
 > transport_wait_for_tasks() stuck. Should the guard cover only the
 > CMD_T_ABORTED branch, or do you see a reason it is safe across both?

Please limit the guard to the CMD_T_ABORTED branch. The only things in
target_cmd_interrupted() that must not run twice are in that branch:
INIT_WORK() + queue_work() on cmd->work, and the
transport_complete_callback() call. For COMPARE AND WRITE the latter
releases dev->caw_sem in compare_and_write_callback(), so calling it
twice would release that semaphore twice.

The CMD_T_STOP branch doesn't need a guard. complete_all() is
idempotent and t_transport_stop_comp is initialized only once, in
__target_init_cmd(). Suppressing a repeated complete_all() wouldn't
strand a waiter either, since the completion stays done. However, a
guard shared by both branches would be wrong for another reason: if
the first call takes the CMD_T_STOP branch and CMD_T_ABORTED is set
afterwards, a shared guard would suppress queueing target_abort_work
and we would be back to the target_put_cmd_and_wait() hang.

Something like this (untested):

	static bool target_cmd_interrupted(struct se_cmd *cmd)
	{
		bool queue_abort = false, stop = false;
		unsigned long flags;
		int post_ret;

		spin_lock_irqsave(&cmd->t_state_lock, flags);
		if (cmd->transport_state & CMD_T_ABORTED) {
			if (cmd->transport_state & CMD_T_ABORT_QUEUED) {
				spin_unlock_irqrestore(&cmd->t_state_lock,
						       flags);
				return true;
			}
			cmd->transport_state |= CMD_T_ABORT_QUEUED;
			queue_abort = true;
		} else if (cmd->transport_state & CMD_T_STOP) {
			stop = true;
		}
		spin_unlock_irqrestore(&cmd->t_state_lock, flags);

		if (!queue_abort && !stop)
			return false;
		if (cmd->transport_complete_callback)
			cmd->transport_complete_callback(cmd, false,
							 &post_ret);
		if (queue_abort) {
			INIT_WORK(&cmd->work, target_abort_work);
			queue_work(target_completion_wq, &cmd->work);
		} else {
			complete_all(&cmd->t_transport_stop_comp);
		}
		return true;
	}

Notes:
- Please use spin_lock_irqsave(): target_complete_cmd() may be called by
   backend drivers from interrupt context.
- Call the callback and queue_work() after unlocking t_state_lock,
   like the current code does.
- A repeated call in the aborted case must still return true so that
   callers don't proceed with normal completion.
- Please describe in the patch description that the second call is a
   no-op by design and that fabrics that complete once are unaffected.

Thanks,

Bart.
