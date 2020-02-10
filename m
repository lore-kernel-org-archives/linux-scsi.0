Return-Path: <SRS0=AJIY=36=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC2BCC35254
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 18:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE69220838
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 18:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581359208;
	bh=S3+C0t+M91aUiZrXVskt6ELeMwjSfvq0ROIk4N7K9ls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fX37x7CtWmNAKH114dESTJaywgbledk4mrBNHzZ0LbUstmvi8e77+iknNVNtmU7tU
	 d7toO9rNveL6uM3f/qFV46xtjfCrowW1/9IOFhut+o1tAi1x9SknTKqFbJT1lcirdU
	 QjG8AOkZjwVtB+H5mXUa1eAbjzRfVG8NyeIobHSw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgBJS0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Feb 2020 13:26:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726809AbgBJS0r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Feb 2020 13:26:47 -0500
Received: from dhcp-10-100-145-180.wdl.wdc.com (unknown [199.255.45.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE29C2080C;
        Mon, 10 Feb 2020 18:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581359207;
        bh=S3+C0t+M91aUiZrXVskt6ELeMwjSfvq0ROIk4N7K9ls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PGIzl/AQfYGtsiF/gKwoJrHfsMEJqriEgMzoOTxFHnpw5XCM3RbU6fiHymEvcEMWm
         16YRUkQQE49lbbtEMMyVP8cPJEbUTnXt82aZLlalSh0jkSxvK18h78qGqXEMM2mWVB
         TjFwk0jhJKz3QWHGXCd6t3Iugkc3S0KZPZnT/Cwo=
Date:   Mon, 10 Feb 2020 10:26:45 -0800
From:   Keith Busch <kbusch@kernel.org>
To:     Muhammad Ahmad <muhammad.ahmad@seagate.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Tim Walker <tim.t.walker@seagate.com>
Subject: Re: [LSF/MM/BPF TOPIC] Multi-actuator HDDs
Message-ID: <20200210182645.GA2535@dhcp-10-100-145-180.wdl.wdc.com>
References: <CAPNbX4RxaZLi9F=ShVb85GZo_nMFaMhMuqhK50d5CLaarVDCeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPNbX4RxaZLi9F=ShVb85GZo_nMFaMhMuqhK50d5CLaarVDCeg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 10, 2020 at 12:01:13PM -0600, Muhammad Ahmad wrote:
> For NVMe HDDs are namespaces the appropriate abstraction of the
> multiple actuators?

This sounds closer to what "NVM Sets" defines rather than namespaces.
Section 4.9 from NVMe 1.4 spec has additional details if interested.
