From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [PATCH 4/7] iscsi-target: Make a variable initialisation a bit
 more obvious in iscsi_create_default_params()
Date: Sat, 12 Dec 2015 16:02:16 +0100
Message-ID: <566C36F8.7040704@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <566C2F7B.6030704@users.sourceforge.net>
 <566C3225.4070100@users.sourceforge.net>
 <alpine.DEB.2.10.1512121545230.2512@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1512121545230.2512@hadrien>
Sender: kernel-janitors-owner@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>> @@ -200,9 +200,8 @@ free_param:
>>  int iscsi_create_default_params(struct iscsi_param_list **param_list_ptr)
>>  {
>>  	struct iscsi_param *param;
>> -	struct iscsi_param_list *pl;
>> +	struct iscsi_param_list *pl = kzalloc(sizeof(*pl), GFP_KERNEL);
>>
>> -	pl = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
> 
> I don't see the benefit of this change, and the pattern assignment ->
> failure test becomes more obscure.

Are there any more software developers who prefer to specify
such a variable initialisation on a single line?

Does the proposed small source code reduction matter for you?

Regards,
Markus
