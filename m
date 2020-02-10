Return-Path: <SRS0=AJIY=36=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F32C3B186
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 22:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7955D20863
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Feb 2020 22:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgBJW0B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Feb 2020 17:26:01 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33440 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbgBJW0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2020 17:26:01 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 1B613283A7;
        Mon, 10 Feb 2020 17:25:57 -0500 (EST)
Date:   Tue, 11 Feb 2020 09:25:59 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Keith Busch <kbusch@kernel.org>
cc:     Tim Walker <tim.t.walker@seagate.com>, linux-block@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nvme@lists.infradead.org
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
In-Reply-To: <20200210204313.GA3736@dhcp-10-100-145-180.wdl.wdc.com>
Message-ID: <alpine.LNX.2.22.394.2002110914510.9@nippy.intranet>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com> <20200210204313.GA3736@dhcp-10-100-145-180.wdl.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 10 Feb 2020, Keith Busch wrote:

> Right now the nvme driver unconditionally sets QUEUE_FLAG_NONROT 
> (non-rational, i.e. ssd), on all nvme namespace's request_queue flags. 

I agree -- the standard nomenclature is not rational ;-) Air-cooled is not 
"solid state". Any round-robin algorithm is "rotational". No expensive 
array is a "R.A.I.D.". There's no "S.C.S.I." on a large system...
