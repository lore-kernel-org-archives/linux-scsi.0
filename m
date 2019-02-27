From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] scsi: aacraid: Fix missing break in switch statement
Date: Wed, 27 Feb 2019 14:07:21 -0600
Message-ID: <3c201ff6-fdcf-f04d-c5dd-0f826fab555b@embeddedor.com>
References: <20190215214242.GA8393@embeddedor> <yq1pnrd9u7o.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1pnrd9u7o.fsf@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org



On 2/27/19 8:33 AM, Martin K. Petersen wrote:
> 
> Gustavo,
> 
>> Add missing break statement and fix identation issue.
> 
> So much bad indentation in this driver. Tried various tab widths and it
> is still all over the place.
> 
> Anyway. After staring at the firmware header I have convinced myself
> that your fix is correct. Applied to 5.1/scsi-queue.
> 

That's great.

Thanks, Martin.

--
Gustavo
