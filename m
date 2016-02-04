From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [mpt3sas driver 09/10] mpt3sas: Fix for Asynchronous completion
 of timedout IO and task abort of timedout IO.
Date: Thu, 4 Feb 2016 16:07:56 +0100
Message-ID: <56B3694C.80707@redhat.com>
References: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
 <1453963027-19770-10-git-send-email-suganath-prabu.subramani@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453963027-19770-10-git-send-email-suganath-prabu.subramani@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath prabu Subaramani <suganath-prabu.subramani@avagotech.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, chaitra.basappa@avagotech.com, sreekanth.reddy@avagotech.com
List-Id: linux-scsi@vger.kernel.org

On 28.1.2016 07:37, Suganath prabu Subaramani wrote:
> From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
>
> Track msix of each IO and use the same msix for issuing
> abort to timed out IO. With this driver will process IO's
> reply first followed by TM.
>
> Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
> Signed-off-by: Chaitra P B <chaitra.basappa@avagotech.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
