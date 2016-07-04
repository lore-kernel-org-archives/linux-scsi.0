From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 2/2] libata-scsi: do not response with "invalid field" for
 FORMAT UNIT
Date: Tue, 5 Jul 2016 00:27:50 +0300
Message-ID: <2c7e733e-a714-609e-d71e-9d5f4e81b44b@cogentembedded.com>
References: <20160704205335.5484-1-me>
 <577accda.46c0620a.65070.ffffec86@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <577accda.46c0620a.65070.ffffec86@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com, tj@kernel.org, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/04/2016 11:53 PM, tom.ty89@gmail.com wrote:

> From: Tom Yan <tom.ty89@gmail.com>
>
> It does not make sense and is confusing to response with "Invalid

    Respond here and in the subject.

> field in cbd" while we have no support at all implemented for
> FORMAT UNIT. It is decent to let it go to the default, which
> will response with "Invalid command operation code" instead.
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

MBR, Sergei

