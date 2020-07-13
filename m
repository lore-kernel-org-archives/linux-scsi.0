Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA2BC433E5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 16:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39E6820738
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 16:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbgGMQmC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 12:42:02 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:64631 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730314AbgGMQmB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 12:42:01 -0400
Received: from localhost (varun.asicdesigners.com [10.193.191.116])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06DGfw4e003776;
        Mon, 13 Jul 2020 09:41:59 -0700
Date:   Mon, 13 Jul 2020 22:11:58 +0530
From:   Varun Prakash <varun@chelsio.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-scsi@vger.kernel.org, varun@chelsio.com
Subject: Re: [bug report] scsi: cxgb4i: Add support for iSCSI segmentation
 offload
Message-ID: <20200713164157.GC1780@chelsio.com>
References: <20200710141729.GA135776@mwanda>
 <20200710142903.GJ2571@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710142903.GJ2571@kadam>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 10, 2020 at 05:29:03PM +0300, Dan Carpenter wrote:
> On Fri, Jul 10, 2020 at 05:17:29PM +0300, dan.carpenter@oracle.com wrote:
> > Hello Varun Prakash,
> > 
> > This is a semi-automatic email about new static checker warnings.
> > 
> > The patch e33c2482289b: "scsi: cxgb4i: Add support for iSCSI 
> > segmentation offload" from Jun 29, 2020, leads to the following 
> > Smatch complaint:
> > 
> >     drivers/scsi/cxgbi/libcxgbi.c:2158 cxgbi_conn_init_pdu()
> >     warn: variable dereferenced before check 'tdata' (see line 2150)
> > 
> 
> Same issue in cxgbi_conn_xmit_pdu() as well.
> 
> drivers/scsi/cxgbi/libcxgbi.c:2374 cxgbi_conn_xmit_pdu() warn: variable dereferenced before check 'tdata' (see line 2368)

Patch is already posted for this issue
https://patchwork.kernel.org/patch/11654403/
