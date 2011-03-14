From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [RFC-v2 01/12] iscsi: Resolve iscsi_proto.h naming conflicts
 with drivers/target/iscsi
Date: Mon, 14 Mar 2011 17:13:30 -0500
Message-ID: <4D7E930A.1010503@cs.wisc.edu>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>	 <1300103829-10337-2-git-send-email-nab@linux-iscsi.org>	 <20110314145930.GB28480@lst.de> <1300138856.28255.133.camel@haakon2.linux-iscsi.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <open-iscsi+bncCLPJla3WGRCBpvrrBBoEdj55QQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1300138856.28255.133.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Open iSCSI <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2011 04:40 PM, Nicholas A. Bellinger wrote:
> On Mon, 2011-03-14 at 15:59 +0100, Christoph Hellwig wrote:
>> On Mon, Mar 14, 2011 at 04:56:58AM -0700, Nicholas A. Bellinger wrote:
>>> From: Nicholas Bellinger<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
>>>
>>> This patch renames the following iscsi_proto.h structures to avoid
>>> namespace issues with drivers/target/iscsi/iscsi_target_core.h:
>>>
>>> *) struct iscsi_cmd ->  struct iscsi_scsi_cmd
>>
>> This name is not overly descriptive.  Using _req/_rsp uniformly would make a
>> lot more sense.
>>
>
> Mmmm, fair point here..  I don't have a strong preference so I will
> defer to Mike and Hannes on this (open-iscsi CC'ed).  Guys is this OK
> with you..?
>

Ok with me.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
