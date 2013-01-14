From: Sergei Shtylyov <sshtylyov@mvista.com>
Subject: Re: [PATCH] Fix libata-eh don't retry command after reset succeeded.
Date: Mon, 14 Jan 2013 20:41:47 +0300
Message-ID: <50F4435B.1000705@mvista.com>
References: <201301141820562689358@gmail.com> <50F40FA8.4070101@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <50F40FA8.4070101@teksavvy.com>
Sender: linux-ide-owner@vger.kernel.org
To: ycbzzjlby <ycbzzjlby@gmail.com>
Cc: Mark Lord <kernel@teksavvy.com>, jgarzik <jgarzik@redhat.com>, mlord <mlord@pobox.com>, linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello.

On 01/14/2013 05:01 PM, Mark Lord wrote:

>> From 9cc9a85f17a8525e53caf430611d762c105d324c Mon Sep 17 00:00:00 2001
>> From: Bian Yu <ycbzzjlby@gmail.com>
>> Date: Tue, 18 Dec 2012 05:58:34 -0500
>> Subject: [PATCH] Fix libata-eh don't retry command after reset succeeded.
>>  It's introduced by commit 8d899e70c1b3afff, When disk has a UNC error,

   Please also specify that commit's summary in parens.

>>  qc->err_mask will set AC_ERR_MEDIA flag.
>>  Signed-off-by: Bian Yu <ycbzzjlby@gmail.com>

MBR, Sergei

