From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 02/10] mpt3sas: Fixed memory leaks in driver
Date: Wed, 11 Oct 2017 17:30:08 +0200
Message-ID: <ea7bf7e2-ca5c-5618-10b2-e62c8149dfab@redhat.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
 <1507641083-20207-3-git-send-email-Sreekanth.Reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507641083-20207-3-git-send-email-Sreekanth.Reddy@broadcom.com>
Content-Language: en-MW
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/10/2017 03:11 PM, Sreekanth Reddy wrote:
> Fixed below memory leak in driver,
>
> * While removing Expander devices - we are removing expander
>  device entry from the list before freeing it's child devices,
>  so while freeing child device we are finding its parent device
>  node as NULL and so we are not freeing the child device's
>  allocated data structures.
>  Updated the driver to remove the expander device from the list
>  only after freeing all its child devices.
>
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

Signed-off-by: Tomas Henzl <thenzl@redhat.com>

Tomas
