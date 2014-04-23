From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCHv2 RESEND 0/9] target: Save memory on unused se_dev_entrys
 and se_luns
Date: Wed, 23 Apr 2014 15:36:27 -0700
Message-ID: <5358406B.5040906@redhat.com>
References: <1395704598-31073-1-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1395704598-31073-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 03/24/2014 04:43 PM, Andy Grover wrote:
> Hi nab, hch, and all,
>
> This patchset reduces the amount of memory for se_dev_entry and se_lun
> arrays by waiting to allocate array members, and includes some related
> simplification patches too. This is a rework of a few patches I submitted
> in December in a larger series, but keeping it simple by sticking with
> fixed-size arrays for device_list and tpg_lun_list for now.
>
> Testing: created and removed luns and mapped luns, worked ok.
>
> Changes in resend:
>    Rebase to latest target-pending/for-next
> Changes in v2:
>    Added patches 1-2, which ensure locking around the arrays
>    Added patch 9, refactors enable_device_list_for_node
>    Patch 7/6 folded into series

Does this set look ok, or any other changes needed? Just haven't heard 
anything.

Thanks -- Andy
