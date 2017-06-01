From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Eliminate extra 'out_free' label from fcoe_init function
Date: Thu, 1 Jun 2017 15:07:20 +0200
Message-ID: <2b91bd28-61f9-9db0-68d4-7fd25ed6eaa1@suse.de>
References: <a1ea0104-83ed-2249-3450-dc5c31517558@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46529 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751096AbdFANH0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Jun 2017 09:07:26 -0400
In-Reply-To: <a1ea0104-83ed-2249-3450-dc5c31517558@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mgandhi@redhat.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Laurence Oberman <loberman@redhat.com>

On 06/01/2017 02:11 PM, Milan P. Gandhi wrote:
> Simplify the check for return code of fcoe_if_init routine
> in fcoe_init function such that we could eliminate need for
> extra 'out_free' label.
> 
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---

Ahm and what happens to the fcoe_wq then?


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
