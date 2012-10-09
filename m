From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/5]  arcmsr: Re-name the HBA Type
Date: Tue, 09 Oct 2012 14:34:40 +0100
Message-ID: <1349789680.2615.80.camel@dabdike.int.hansenpartnership.com>
References: <E46872A6894149C9B846DBC819D437F5@arecaaebe11fae>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E46872A6894149C9B846DBC819D437F5@arecaaebe11fae>
Sender: linux-kernel-owner@vger.kernel.org
To: NickCheng <nick.cheng@areca.com.tw>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jejb@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-10-09 at 21:23 +0800, NickCheng wrote:
> From: Nick Cheng <nick.cheng@areca.com.tw>
> 
> Replace the nameing, hba, hbb and hbc, with hbaA, hbaB abd hbaC respectively
> Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>

This is still malformed in exactly the same way

> diff -uprN -X linux-vanilla/Documentation/dontdiff
> linux-vanilla//drivers/scsi/arcmsr/arcmsr.h
> linux-development//drivers/scsi/arcmsr/arcmsr.h
> --- linux-vanilla//drivers/scsi/arcmsr/arcmsr.h	2012-10-03

There's a spurious carriage return here which kills the patch
applicability

> 18:29:18.030657090 +0800

James
