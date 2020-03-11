Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7EFAC10F27
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 06:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB7221D56
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 06:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgCKGru (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 02:47:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:53694 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgCKGru (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Mar 2020 02:47:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 10A52AAFD;
        Wed, 11 Mar 2020 06:47:47 +0000 (UTC)
Subject: Re: [PATCH -next 020/491] XEN HYPERVISOR INTERFACE: Use fallthrough;
To:     Joe Perches <joe@perches.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
References: <cover.1583896344.git.joe@perches.com>
 <93cb221f897e6d5d37539d9a8dcf8be7797bd401.1583896348.git.joe@perches.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <cae76ab2-e626-e8ee-4d14-2badc68711b1@suse.com>
Date:   Wed, 11 Mar 2020 07:47:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <93cb221f897e6d5d37539d9a8dcf8be7797bd401.1583896348.git.joe@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11.03.20 05:51, Joe Perches wrote:
> Convert the various uses of fallthrough comments to fallthrough;
> 
> Done via script
> Link: https://lore.kernel.org/lkml/b56602fcf79f849e733e7b521bb0e17895d390fa.1582230379.git.joe.com/
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Juergen Gross <jgross@suse.com>


Juergen
