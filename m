Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.3.219.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793141751;
	b=knTP0pW0VvaYtGZE3N4ceFRBG+ttNqeIXpG20xI6156z5XAyQBzjHv+90cU+8K3RxpPA
	 V6dJuEV7kQRbGSbdo66kAP9NADej0yX9YkZtOJEhso9rTtlOIkBwVAec1r+JgEZO0+jSJ
	 kIe6KggIhLCKLefn6DnnFHG+feq6e2nfd7MQiaQnaxW/I5JnVXXJBQCcF4vznVS1GpsZz
	 JB/gVsGJ7UxJrttb2pcu1iPBtk2Y8ZotDBloDIXOuF8/MGlM5OvjaQ6KK9vp+z2G6eN8+
	 bfqDx0qLM4lwt1cIedudG3ZG6fW+CTqiDAJbeDhIUo5mB+nBQeg3eld6anrmGgQSTcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793141751;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:DKIM-Signature:
	 Received:Received:Date:From:To:CC:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-Originating-IP:
	 X-ClientProxiedBy:X-KSMG-AntiPhishing:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:X-KSMG-KATA-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=ywhaCbnTX+qTpWHanCXUPC4b96UVNtT+R99Ydrulnr8=;
	b=C3JImntZ75ji2LHtASC39WHcczybLnFsKfbik8vt49CI6oCnwGfrkPUL78yq/aeJUPqA
	 K0MaSH58OBWn3UErh3GPuHEhMz9jDYA+mI1QLvE1C+wqui2etiVloqqeOsPOP8QDftMdZ
	 /wr6RF57v/Dr6UBsjmtWadMYk9zSWWUOFQI1olp25+RqN6tuSFkucWVQ+DC5Ugmko3lFY
	 cwpeVylnp/0PSw2gm9yDWywnutHIXpkO6rdcG0Pt4IPk0Pw87S/2GWtpct7pjMMIkHOUh
	 Q4VsxNIwFTieKKFsABMDIGD14LtkD9HmmMU1AaWEzAfHBLhZH5yH1fjHdcZ6FWAZIxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yadro.com;
	spf=pass smtp.mailfrom=yadro.com;
	dkim=pass header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-02 header.b=xJEuQSev;
	dkim=pass header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-03 header.b=GqERLg4l;
	arc=none smtp.remote-ip=195.3.219.148
Received: from mta-01.yadro.com (mta-01.yadro.com [195.3.219.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C8C606A31A;
	Tue, 27 Oct 2026 22:55:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88C8C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-02 header.b=xJEuQSev;
	dkim=pass (2048-bit key, unprotected) header.d=yadro.com header.i=@yadro.com header.a=rsa-sha256 header.s=mta-03 header.b=GqERLg4l
Received: from mta-01.yadro.com (localhost [127.0.0.1])
	by mta-01.yadro.com (Postfix) with ESMTP id 2FF3E20003;
	Wed, 28 Oct 2026 01:55:46 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-01.yadro.com 2FF3E20003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1793141746; bh=ywhaCbnTX+qTpWHanCXUPC4b96UVNtT+R99Ydrulnr8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=xJEuQSevRhbxKUhbXOgkgPSeOU9Q0uMdYWvVYUqvhUwLjBBdBAQyBSg4AAwh+dnBv
	 BpGvEnVSKx/gN3M5ZQcWC/+TiKno6O3211wbkNJ7WGyXIp6gzJ2jOuzU3NElZH+lG7
	 +Nx0KZ3Dfso4RbR72SRX9LejbmC7VijicfnAVizrbNxAeAmq6b/PBrvE5vhaaz8n48
	 VNd/h54KMWO2lbi4GPoR7cgZMlZki+GXSSC1E6Zw00oKAobaXzB1cPC5PmXNQiSNLT
	 w4AHhDnIvD3Uub+bCFgJVhpH1lcc7G5GBpV6KGctUZ95a3ROO+wGqCuuAm1SJ2U1td
	 jAFSorb9rcw5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1793141746; bh=ywhaCbnTX+qTpWHanCXUPC4b96UVNtT+R99Ydrulnr8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=GqERLg4lmGEC4NNEuTury1CqBqvZlHE2OYvAr4ucgHozCsbq28mmT24hSBkq08QEf
	 Y88lqxvqhyyWMayVfE765fMKGHF/2sVewxR5bA7KhLuKsLsjFOUMfO9SDsonJ//RP0
	 GVv4jL/8EMLDaAebkjMn3YizF8n+rMIXsawkx9FJnkE/FUJEBlCBj8R6eRAyDkWxks
	 JmWTZMnqut6KpbbFPelSycihe0VQRJHgMNpcv7/J/oxMZeMSMZM75Jrx1Iip8hyQo2
	 8O6hxvStI1JYdxOB8xalfmjS9sFeKfaThad5+vLysnivT0WP0GGvX1i1ndzhyjSMVH
	 R8zWw9GndgMkw==
Received: from RTM-EXCH-06.corp.yadro.com (unknown [10.34.9.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS;
	Wed, 28 Oct 2026 01:55:45 +0300 (MSK)
Received: from yadro.com (10.34.9.246) by RTM-EXCH-06.corp.yadro.com
 (10.34.9.206) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 28 Oct
 2026 01:55:45 +0300
Date: Wed, 28 Oct 2026 01:55:45 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: <sashiko-reviews@lists.linux.dev>
CC: <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: target: iscsi: fix hanging WRITE_PENDING
 commands
Message-ID: <20261027225545.GA32229@yadro.com>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
 <20261027180123.13163-3-d.bogdanov@yadro.com>
 <sashiko-outbox-187009@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-187009@kernel.org>
X-ClientProxiedBy: RTM-EXCH-01.corp.yadro.com (10.34.9.201) To
 RTM-EXCH-06.corp.yadro.com (10.34.9.206)
X-KSMG-AntiPhishing: NotDetected, bases: 2026/10/27 19:34:00
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/10/27 19:28:00 #28750693
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected, bases: 2026/10/27 19:34:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Tue, Oct 27, 2026 at 06:18:12PM +0000, sashiko-bot@kernel.org wrote:
> 
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: target: iscsi: double completion in iscsit_release_commands_from_conn()
> --
> 
> commit 31a87057639fce26dc0f2f4bbcd6ddacf96b85a5
> Author: Dmitry Bogdanov <d.bogdanov@yadro.com>
> 
> scsi: target: iscsi: fix hanging WRITE_PENDING commands
> 
> This commit removes early CMD_T_ABORTED checks in the iSCSI Data-Out and
> command execution paths so that aborted WRITE commands in WRITE_PENDING state
> are passed to the target core once all Data-Out PDUs have been received.
> 
> > diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> > index 62ada3a52210e..03d618cd76721 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -1518,23 +1518,6 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
> >                       if (hdr->flags & ISCSI_FLAG_CMD_FINAL)
> >                               iscsit_stop_dataout_timer(cmd);
> >
> > -                     return iscsit_dump_data_payload(conn, payload_length, 1);
> > -             }
> > -     } else {
> > -             /*
> > -              * For the normal solicited data path:
> > -              *
> > -              * Check for a delayed TASK_ABORTED status and dump any
> > -              * incoming data out payload if one exists.  Also, when the
> > -              * ISCSI_FLAG_CMD_FINAL is set to denote the end of the current
> > -              * data out sequence, we decrement outstanding_r2ts.  Once
> > -              * outstanding_r2ts reaches zero, go ahead and send the delayed
> > -              * TASK_ABORTED status.
> > -              */
> > -             if (se_cmd->transport_state & CMD_T_ABORTED) {
> > -                     if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
> > -                         --cmd->outstanding_r2ts < 1)
> > -                             iscsit_stop_dataout_timer(cmd);
> 
> [Severity: High]
> Could passing an aborted WRITE_PENDING command to target_execute_cmd() cause
> a double abort completion and use-after-free if the connection closes afterward
> in iscsit_release_commands_from_conn()?

Yes, it can cause. But my patch neither was intended to address that
problem neither increases its probability. WRITE_PENDING always may be
aborted, in parallel from other session, right
before target_cmd_interrupted() in target_execute_cmd().

And that is easily fixed by changing cmd->t_state in
target_execute_cmd() before target_cmd_interrupted() to take the
cmd ownership by the target core:

-----------------
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2c9f4b58c024f..14ea1a9d7fa40 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2561,6 +2561,10 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 void target_execute_cmd(struct se_cmd *cmd)
 {
        trace_target_execute_cmd(cmd);
+
+       spin_lock_irq(&cmd->t_state_lock);
+       cmd->t_state = TRANSPORT_PROCESSING;
+       spin_unlock_irq(&cmd->t_state_lock);
        /*
         * Determine if frontend context caller is requesting the stopping of
         * this command for frontend exceptions.
@@ -2571,7 +2575,6 @@ void target_execute_cmd(struct se_cmd *cmd)
                return;

        spin_lock_irq(&cmd->t_state_lock);
-       cmd->t_state = TRANSPORT_PROCESSING;
        cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
        spin_unlock_irq(&cmd->t_state_lock);

---------------


> 
> With this check removed in __iscsit_check_dataout_hdr(), an aborted WRITE
> command in TRANSPORT_WRITE_PENDING state receives its remaining Data-Out PDUs
> and calls target_execute_cmd() in iscsit_check_dataout_payload() (or in
> iscsit_execute_cmd() for out-of-order CmdSNs):
> 
> drivers/target/iscsi/iscsi_target.c:iscsit_check_dataout_payload() {
>         ...
>                 iscsit_stop_dataout_timer(cmd);
>                 if (ooo_cmdsn)
>                         return 0;
>                 target_execute_cmd(&cmd->se_cmd);
>                 return 0;
>         ...
> }
> 
> In target_execute_cmd(), target_cmd_interrupted() is called before
> cmd->t_state is updated to TRANSPORT_PROCESSING:
> 
> drivers/target/target_core_transport.c:target_execute_cmd() {
>         if (target_cmd_interrupted(cmd))
>                 return;
> 
>         spin_lock_irq(&cmd->t_state_lock);
>         cmd->t_state = TRANSPORT_PROCESSING;
>         cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
>         spin_unlock_irq(&cmd->t_state_lock);
>         ...
> }
> 
> Because CMD_T_ABORTED is set, target_cmd_interrupted() queues
> target_abort_work on target_completion_wq and returns true without changing
> cmd->t_state:
> 
> drivers/target/target_core_transport.c:target_cmd_interrupted() {
>         ...
>         if (cmd->transport_state & CMD_T_ABORTED) {
>                 if (cmd->transport_complete_callback)
>                         cmd->transport_complete_callback(cmd, false, &post_ret);
>                 INIT_WORK(&cmd->work, target_abort_work);
>                 queue_work(target_completion_wq, &cmd->work);
>                 return true;
>         }
>         ...
> }
> 
> As a result, cmd->se_cmd.t_state remains TRANSPORT_WRITE_PENDING. When
> CMD_T_TAS is set (for example, when aborted by a LUN_RESET on another session
> with emulate_tas enabled), target_handle_abort() queues SAM_STAT_TASK_ABORTED
> status and drops one cmd_kref reference via
> transport_cmd_check_stop_to_fabric(), leaving the command on
> conn->conn_cmd_list in TRANSPORT_WRITE_PENDING state until ExpStatSN
> acknowledges the status (or, when CMD_T_TAS is not set, until
> target_abort_work runs iscsit_aborted_task()).
> 
> If the connection closes while the command is still on conn->conn_cmd_list,
> iscsit_release_commands_from_conn() checks for TRANSPORT_WRITE_PENDING:
> 
> drivers/target/iscsi/iscsi_target.c:iscsit_release_commands_from_conn() {
>         ...
>                 if (cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING) {
>                         /*
>                          * We never submitted the cmd to LIO core, so we have
>                          * to tell LIO to perform the completion process.
>                          */
>                         spin_unlock_irq(&se_cmd->t_state_lock);
>                         target_complete_cmd(&cmd->se_cmd, SAM_STAT_TASK_ABORTED);
>                         continue;
>                 }
>         ...
> }
> 
> Wouldn't this call target_complete_cmd() -> target_cmd_interrupted() a second
> time on the same command, re-initializing and re-queueing cmd->work for
> target_abort_work while iscsit_release_commands_from_conn() also frees the
> command via iscsit_free_cmd(), leading to workqueue corruption, cmd_kref
> underflow, and use-after-free of struct iscsit_cmd?
> 
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261027180123.13163-1-d.bogdanov@yadro.com?part=2
