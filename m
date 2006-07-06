From: Henne <henne@nachtwindheim.de>
Subject: Re: [KJ] [PATCH] fix legacy megaraid-driver to compile without CONFIG_PROC_FS
Date: Thu, 06 Jul 2006 22:33:49 +0200
Message-ID: <44AD73AD.5080402@nachtwindheim.de>
References: <44AD6A5A.5060403@nachtwindheim.de> <20060706131447.ed46c3cb.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750818AbWGFUcb@vger.kernel.org>
In-Reply-To: <20060706131447.ed46c3cb.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Neela.Kolli@engenio.com, kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>> From: Henrik Kretzschmar <henne@nachtwindheim.de>
>>
>> Create an empty inline function to make the legacy megaraid-driver compile
>> without PROC_FS.
>> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
>> ---
>>
>> --- linux-2.6.18-rc1/drivers/scsi/megaraid.h    2006-06-18 03:49:35.000000000 +0200
>> +++ linux/drivers/scsi/megaraid.h       2006-07-06 21:39:59.000000000 +0200
>> @@ -1039,6 +1039,9 @@
>>  static int proc_rdrv_30(char *, char **, off_t, int, int *, void *);
>>  static int proc_rdrv_40(char *, char **, off_t, int, int *, void *);
>>  static int proc_rdrv(adapter_t *, char *, int, int);
>> +#else
>> +static inline void
>> +mega_create_proc_entry(int index, struct proc_dir_entry *parent) {}
>>  #endif
>>
>>  static int mega_adapinq(adapter_t *, dma_addr_t);
> 
> Already in -mm:
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.17/2.6.17-mm6/broken-out/drivers-scsi-megaraidc-add-a-dummy-mega_create_proc_entry-for-proc_fs=y.patch
Great, but isn't it better to put that define stuff into the headers?

Thanks and Greets,
Henne
