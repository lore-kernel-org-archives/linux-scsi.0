From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [mpt3sas driver 03/10] mpt3sas: Fix static analyzer(coverity)
 tool identified defects
Date: Thu, 4 Feb 2016 15:18:51 +0100
Message-ID: <56B35DCB.3000408@redhat.com>
References: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
 <1453963027-19770-4-git-send-email-suganath-prabu.subramani@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453963027-19770-4-git-send-email-suganath-prabu.subramani@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath prabu Subaramani <suganath-prabu.subramani@avagotech.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, chaitra.basappa@avagotech.com, sreekanth.reddy@avagotech.com
List-Id: linux-scsi@vger.kernel.org

On 28.1.2016 07:37, Suganath prabu Subaramani wrote:
> From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
>
> 1.Wrong size of argument is being passed
>  The size of struct being passed as an argument to memset func and area of
>  memory being pointed by an instance of struct in memset func should be of
>  same structure type.
> 2.Dereference null return value
> 3.Array compared against '0'
>  Check whether value pointed by particular index of an array is null or not
>  in "if" statement.
>
> Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
> Signed-off-by: Chaitra P B <chaitra.basappa@avagotech.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas
