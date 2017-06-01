From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Remove an extra out label in _fcoe_create function
Date: Thu, 1 Jun 2017 15:05:16 +0200
Message-ID: <ce2dc5ed-cf90-274f-3f6c-1b22018978bb@suse.de>
References: <0d0539e8-ec2e-eac3-a91b-bfda55e83eca@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46143 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751083AbdFANFS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Jun 2017 09:05:18 -0400
In-Reply-To: <0d0539e8-ec2e-eac3-a91b-bfda55e83eca@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mgandhi@redhat.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, Johannes Thumshirn <jth@kernel.org>

On 06/01/2017 02:08 PM, Milan P. Gandhi wrote:
> This patch removes an extra out label in _fcoe_create function
> where we return if creation of FCOE interface is failed.
> 
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---

Thanks,
Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
