From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 5/8] BNX2I: Added TCP timestamps option support
Date: Wed, 5 Jan 2011 16:39:36 -0800
Message-ID: <1294274378.1988.111.camel@ltirv-waie-lx1>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1294260267-17413-6-git-send-email-eddie.wai@broadcom.com>
 <4D24DA01.9060709@cs.wisc.edu> <4D24DD45.8060701@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCKiEw6yjEhCunZTpBBoEQwvTmw-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <4D24DD45.8060701-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Cc: "open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Eddie Wai <waie-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, James Bottomley <JBottomley-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Benjamin Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


On Wed, 2011-01-05 at 13:06 -0800, Mike Christie wrote:
> On 01/05/2011 02:52 PM, Mike Christie wrote:
> > On 01/05/2011 02:44 PM, Eddie Wai wrote:
> >> This TCP timestamps option is a module wise feature which can be
> >> enabled via the module param (time_stamps). Once enabled, the TCP
> >> connection will advertise timestamps as an option to get negotiated.
> >>
> >
> > Is there any reason this has to be module wide? Can the hw support
> > having it per connection?
> >
> 
Ya, the hw can indeed support TCP time stamp on a per connection based.
It would be great if perhaps we can support this via open-iscsi and have
a tcp option's parameter in the nodes?

> Oh yeah, what other tcp settings do you guys have? And do you have 
> something like a send/recv window setting?
At this time, the TCP windows/scale setting is not an option we can
alter from the driver.  But some of the other options like delay ACK,
nagle, sack are supported (depends on individual chipset as well).
> 



-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
