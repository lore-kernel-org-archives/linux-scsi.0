From: Ilias Tsitsimpis <iliastsi@arrikto.com>
Subject: Re: [PATCH] tcmu: Skip Data-Out blocks before gathering Data-In
 buffer for BIDI case
Date: Fri, 31 Mar 2017 23:46:22 +0300
Message-ID: <20170331204622.pjlvgb5xchboejhz@iliastsi-m.arr>
References: <1490927725-25131-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0.arrikto.com ([212.71.252.59]:54954 "EHLO mx0.arrikto.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932630AbdCaUqZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 31 Mar 2017 16:46:25 -0400
Content-Disposition: inline
In-Reply-To: <1490927725-25131-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lixiubo@cmss.chinamobile.com
Cc: nab@linux-iscsi.org, mchristi@redhat.com, agrover@redhat.com, namei.unix@gmail.com, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Xiubo,

On Fri, Mar 31, 2017 at 10:35AM, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> For the bidirectional case, the Data-Out buffer blocks will always at
> the head of the tcmu_cmd's bitmap, and before gathering the Data-In
> buffer, first of all it should skip the Data-Out ones, or the device
> supporting BIDI commands won't work.
> 
> Fixed: 26418649eead ("target/user: Introduce data_bitmap, replace
> 		data_length/data_head/data_tail")
> Reported-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>

Thanks for taking care of this.

Tested-by: Ilias Tsitsimpis <iliastsi@arrikto.com>

Best,

-- 
Ilias
