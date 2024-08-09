Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8710018C908;
	Fri,  9 Aug 2024 07:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.248
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723189816; cv=none; b=l0ZfWJo09k88uP3Q6QSU3tOpKNkaRvWIJdMc1Z77TrJKaTZZoffTH29FCPDfZTwkDY/5UKVTSROQcOt8cDjcZW0C7BShE4A7SDuJnu4L+EsJ2w7Nm1jA+5S4QBg1JQM4b4MrgWsjsEMEuWdJ1TbAQt407XWTCOgRa2K49iJCRw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723189816; c=relaxed/simple;
	bh=TaQpOVkVL1egKNnraaxTcWlMHhpJtOeA23li9+lwPqw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVXJT2x5hu6K4JNvFiefX8rAwsM5tPyjg7b1Ox2DMm3Dhsep24pu0Yib/1pLyWffGtEBxVPA8tf8jnye2Cwtt4p/YHMxIZYmtKC0HxIzV2ThMp48IiOeh5qcqZAS+eqDmoStwlzl2s4RN6GkdY5rX87B0Ct+Vy2NmkSHb16Vo4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=NIJPmys3; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=eRD2VAL+; arc=none smtp.client-ip=89.207.88.248
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="NIJPmys3";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="eRD2VAL+"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com 0E90CC0003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1723189203; bh=wAcF8uyZxnAW141A3dKIhLYt7b1xk+sbsvmRKPKz5YM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=NIJPmys3ojGCudaoPbf9y0rR74MOUDqPqWjac1vF8gw73YR71GKLKcK1TdCYOs0Wn
	 jiBBVCfBP59aTEnQq2Djnb03B1Fl0JzoVsnJST4CH9RPa8zxjPTiIvDm0OL8DjRiYP
	 qaoSLgi3tmbeboZ2wKS4qmpS92c125GaLMo2smrKyHmUzbTM723vXNKVEuMOJcxAJB
	 BRgCv/VQ+EW8O48Zgyc8HOwOtMCXXBXxvYVTlmVcgj2GfuHQX4JLOSJ0Ucdh4f8xT6
	 5I8pgA7e6CIKM5nc4MWLYLY9ymuY+KGWmvk3w+WcTOKMc/jjSCWMpb9joc8ZBG0Tlv
	 pYkYZeIWnqe6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1723189203; bh=wAcF8uyZxnAW141A3dKIhLYt7b1xk+sbsvmRKPKz5YM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=eRD2VAL+IC8FyQXlS9h0+pS4IxeEYSiyYfqcW9+0iTFkYGNHSMjFcjho8+tj7/ik6
	 noJHP/l5hSTZ8fwKMNyQ4lPRLi5IcBghk+zZyegvyzAHO0e0y5MfM7D+tJqXRq83dQ
	 dVOJLn9gtu6V5o+NjYKhX1wteQsUCX+lT8yK+lz1aDf/J464PuTNxP795H/WWgFqUY
	 bqOaDftRmT0loagEEOY1SjejBMNxoylhMqkNvn4sP2pZVeUJaGYreGH8Nfk+oyZMzp
	 PqwTLEkKhNjX8tl7kooXyJU0Amvqhq1YOT2jICAkDoPbOReyV0Thjh4Tqxu4IUNxq7
	 bGZKWf59qBwTQ==
Date: Fri, 9 Aug 2024 10:39:58 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Paul Dagnelie <paul.dagnelie@perforce.com>
CC: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"mlombard@redhat.com" <mlombard@redhat.com>, David Mendez
	<david.mendez@perforce.com>
Subject: Re: Leak of tpg->np_login_sem, possibly due to connection
 interruptions
Message-ID: <20240809073958.GA30598@yadro.com>
References: <SJ0PR20MB5136CD6B38D86FD141070F7E80B82@SJ0PR20MB5136.namprd20.prod.outlook.com>
 <SJ0PR20MB5136C6C85B1B82FF78ADECE680B82@SJ0PR20MB5136.namprd20.prod.outlook.com>
 <SJ0PR20MB5136A763BB1792A1FDECABD780BA2@SJ0PR20MB5136.namprd20.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <SJ0PR20MB5136A763BB1792A1FDECABD780BA2@SJ0PR20MB5136.namprd20.prod.outlook.com>
X-ClientProxiedBy: T-EXCH-09.corp.yadro.com (172.17.11.59) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

Hi Paul,
> 
> I've done some more digging into this. I still would really appreciate any advice that folks have on how to root cause and fix this bug.
> 
> I have access to a core file from a system that was taken while the system was suffering from this issue. In that core dump, we can see that the thread in __transport_wait_for_tasks is waiting for the LUN_RESET command to complete. This lead me to realize that in the syslog output, the LUN_RESET message that occured when the issue first happened is different from the other LUN_RESET commands I see: We never get the "LUN_RESET: TMR for [iblock] Complete" message. That lead me to look for the thread that is blocked in processing the LUN_RESET command. That thread's stack trace looks like this:
> 
> 0xffff9416b0fa2080 UNINTERRUPTIBLE       4
>                   __schedule+0x2bd
>                   ...
>                   target_put_cmd_and_wait+0x5a
>                   core_tmr_drain_state_list
>                   core_tmr_lun_reset+0x4e3
>                   target_tmr_work+0xd1
>                   ...
> 
> The command *that* thread is waiting for has a t_state of TRANSPORT_WRITE_PENDING, and it's transport_state is CMD_T_ABORTED. However, it still has a cmd_kref value of 2, which is why the LUN_RESET command can't proceed. It looks like it's a write command (execute_cmd is sbc_execute_rw and data_direction is DMA_TO_DEVICE). I'm still investigating further to try to understand how this state of offairs could occur. Any insight or information anyone could provide would be greatly appreciated.

5.15 is too old kernel for iSCSI, there were plenty of patches that fix
commands hanging there.

Definitely you need this patchset for the beginning:
https://lore.kernel.org/all/20230319015620.96006-1-michael.christie@oracle.com/


BR,
 Dmitry
