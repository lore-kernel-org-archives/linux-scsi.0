From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 01/10] mpt3sas: Fix for improper info displayed in var
 log, while blocking or unblocking the device.
Date: Tue, 25 Oct 2016 16:37:33 +0200
Message-ID: <cde0980b-1208-9dd7-0329-c1099c0ab1fc@redhat.com>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-2-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476966018-10457-2-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 20.10.2016 14:20, Suganath Prabu S wrote:
> Return value and Device_handle Arguments passed in correct order
>  to match with its format string.
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
