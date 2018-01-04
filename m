From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] scsi: fix iscsi-related kernel-doc warnings
Date: Wed, 3 Jan 2018 21:58:58 -0800
Message-ID: <617cf496-3fe0-6834-1a6c-57d5adc2f027@infradead.org>
References: <44a0f532-b1e9-e0cf-4a61-d592a4306f61@infradead.org>
 <yq1373mxny3.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <yq1373mxny3.fsf-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 01/03/2018 08:11 PM, Martin K. Petersen wrote:
> 
> Randy,
> 
>> Fix kernel-doc warnings in drivers/scsi/ that are related to iscsi
>> support interfaces.
>>
>> Fixes these kernel-doc warnings: (tested by adding these files to a new
>> target.rst documentation file: WIP)
> 
> Applied to 4.16/scsi-queue, thanks!
> 
>> Cc:	"Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
>> Cc:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc:	target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc:	Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>> Cc:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc:	"James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> Cc:	"Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
>      ^^^ checkpatch complains about these spaces.

Hah, those are tabs, not spaces.

scripts/checkpatch.pl (comment) says something about this being a style thing:
# Check signature styles

WARNING: Use a single space after Cc:
#29: 
Cc:	"Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>



Email standards (RFCs) sure don't require a single space.

and I would like to be able to copy N lines from MAINTAINERS file and then
replace either the M: and/or L: (actually just the 'M' or 'L') with
"To" or "Cc" and be done with it, instead of having to replace TAB on each
line with a space also.

Does anyone know where this "signature style" check came from?
I don't see it in any style guide.

thanks,
-- 
~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
