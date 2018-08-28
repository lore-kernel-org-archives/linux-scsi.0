From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: Bug in /drivers/scsi/3w-9xxx.h
Date: Tue, 28 Aug 2018 10:00:24 -0700
Message-ID: <e79d43eb-38cb-8975-08c9-c3937a1276c2@infradead.org>
References: <491de4ae-0ba3-0fce-a400-3ebb41e21ac4@mni.thm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <491de4ae-0ba3-0fce-a400-3ebb41e21ac4@mni.thm.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Frank Kammer <frank.kammer@mni.thm.de>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[add linux-scsi list]

On 08/28/2018 05:23 AM, Frank Kammer wrote:
> Hello,
> 
> I have a 3ware 9650SE RAID-Controller with 20 LUNs. Using an unpachted
> kernel (no matter which version, e.g., 4.12.14) , only 17 LUNs are shown.
> 
> The problem is that the driver was once written for a 3ware 9550SE
> RAID-Controlle that supports only 16 LUNs.
> There are some changes in driver to allow 32 LUNs, but one change is
> forgotten: 
> 
> In drivers/scsi/3w-9xxx.h, one must replace the following:
> 
> 467c467
> < #define TW_MAX_LUNS(srl) (srl < TW_FW_SRL_LUNS_SUPPORTED ? 1 : 16)
> ---
>> #define TW_MAX_LUNS(srl) (srl < TW_FW_SRL_LUNS_SUPPORTED ? 1 : 32)
> 
> Best regards,
> Frank Kammer
> 


-- 
~Randy
