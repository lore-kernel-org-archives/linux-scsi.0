Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C176347DD50
	for <linux-scsi@vger.kernel.org>; Mon, 11 May 2026 22:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778536921; cv=none; b=Y8Df9d+miTWR8pNucnBZrPDcGtURoOXmu4P5MNLq67hfig34hQvxnvZXl5OTViOFIggCthEaMhNkn/E09T8MUgejkXevFmJs8AbBrNZkuqJdJTyhLntbYqyeNbFzpotgGzaSsNEd5bBAXYiSkt4iLpQvkyVq9rHJWRfsTsI8UW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778536921; c=relaxed/simple;
	bh=LKUo826nacjn9jbG9ku8P2AHZ09zHGUYfTBGoVoQ5ZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M1THtBilaBDEn8pFgaDVGlh0cCn6SmfZvmR3Cw3fzwLxWe32XhSoRhlpYa/JZA4kdLo3gaQDBh9Pzpku+UI212MNQLJMcvHYGVaL62d4fCfQf54tIkU4xeqD88Ks3PaklxdC4cYgPKtQ1TYhCH/rGloaXykUr/CvgSvAgkqwcfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZEFvwR58; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZEFvwR58"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778536917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TzxlEOWA/FoJD7waUR3vxUzQPjUa5F0lD4eH+UzouE0=;
	b=ZEFvwR5862kYeko75bIYUX4bwrc1lO18ItgDPUuvBl0GZu5cfh9DvGWgBxTmlF52FjKxP/
	d5Sy64j1RyHgI57bxd1nT1e4jHpkE/gyPEI1S1An8Dib8WISlfgRvoNmpcMDqZFofIirrA
	k7XD0jwIc+CSilOYAy8joFnEhspLSoI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615--ehzZgtdPBmOURxhq7HLWw-1; Mon,
 11 May 2026 18:01:53 -0400
X-MC-Unique: -ehzZgtdPBmOURxhq7HLWw-1
X-Mimecast-MFC-AGG-ID: -ehzZgtdPBmOURxhq7HLWw_1778536912
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73D3318002DC;
	Mon, 11 May 2026 22:01:51 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (headnet01.pony-001.prod.iad2.dc.redhat.com [10.2.32.101])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 6F4B519560A2;
	Mon, 11 May 2026 22:01:49 +0000 (UTC)
Date: Mon, 11 May 2026 15:01:48 -0700
From: Chris Leech <cleech@redhat.com>
To: Wang Yan <wangyan01@kylinos.cn>
Cc: lduncan@suse.com, michael.christie@oracle.com, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, open-iscsi@googlegroups.com, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libiscsi: fix spelling and format errors
Message-ID: <20260511-resource-blaming-f423310243b5@redhat.com>
References: <20260511093030.63542-1-wangyan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511093030.63542-1-wangyan01@kylinos.cn>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, May 11, 2026 at 05:30:30PM +0800, Wang Yan wrote:
> Fix two issues in libiscsi.c:
> - Correct typo "numer" to "number" in iscsi_session_setup() comment
> - Fix format string "seconds\n." to "seconds.\n" in recv timeout warning
> 
> Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
> ---

Sure, that looks fine.

Reviewed-by: Chris Leech <cleech@redhat.com>

>  drivers/scsi/libiscsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 25857d6ed6e8..160f02f2f51d 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3012,7 +3012,7 @@ static void iscsi_host_dec_session_cnt(struct Scsi_Host *shost)
>   * This can be used by software iscsi_transports that allocate
>   * a session per scsi host.
>   *
> - * Callers should set cmds_max to the largest total numer (mgmt + scsi) of
> + * Callers should set cmds_max to the largest total number (mgmt + scsi) of
>   * tasks they support. The iscsi layer reserves ISCSI_MGMT_CMDS_MAX tasks
>   * for nop handling and login/logout requests.
>   */
> @@ -3307,7 +3307,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
>  
>  	if (conn->ping_timeout && !conn->recv_timeout) {
>  		iscsi_conn_printk(KERN_ERR, conn, "invalid recv timeout of "
> -				  "zero. Using 5 seconds\n.");
> +				  "zero. Using 5 seconds.\n");
>  		conn->recv_timeout = 5;
>  	}
>  
> -- 
> 2.25.1
> 

