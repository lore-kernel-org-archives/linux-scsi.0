From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 2/5]  arcmsr: Support Hibernation
Date: Thu, 07 Feb 2013 18:31:05 +0100
Message-ID: <5113E4D9.2040408@redhat.com>
References: <C9CA5F0351AD4BD282E0579486DA7AB8@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <C9CA5F0351AD4BD282E0579486DA7AB8@arecaaebe11fae>
Sender: linux-kernel-owner@vger.kernel.org
To: NickCheng <nick.cheng@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@kernel.org, =?Big5?B?tsCyTbap?= <ching2048@areca.com.tw>
List-Id: linux-scsi@vger.kernel.org

On 02/06/2013 09:36 AM, NickCheng wrote:
> From: Nick Cheng <nick.cheng@areca.com.tw>
>
> Support hibernation for whole series of RAID controllers
> Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
> ---

Hi Nick,
this patch (2/5) already uses msi-x in the PM part, while the "Support MSI and MSI-X"
is added in the patch 3/5. You should switch the order - the support for msi-x should precede
the use of it in "Support Hibernation".
Tomas
