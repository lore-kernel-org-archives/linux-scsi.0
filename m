From: James Smart <james.smart-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] RFC: The be2iscsi driver support for bsg
Date: Mon, 22 Mar 2010 11:16:31 -0400
Message-ID: <4BA789CF.3040100@emulex.com>
References: <4BA294FC.3030400@cs.wisc.edu>	<20100319081016W.fujita.tomonori@lab.ntt.co.jp>	<4BA3747E.4020104@emulex.com> <20100322175704Y.fujita.tomonori@lab.ntt.co.jp>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <324mnSwsKClg90C4I.IC0HJ4CKB4N.2ECEF4D-8I2I86EE6B46HEKFI.2EC-WNnxsJb2WYALHLMFiseIBxPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
In-Reply-To: <20100322175704Y.fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>,
	<mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org" <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James.Bottomley-l3A5Bk7waGM@public.gmane.org" <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, "open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


FUJITA Tomonori wrote:
> If vendors use the common data structures via bsg, it's totally fine
> by me. I see why bsg is preferable. The only thing that I care about
> is managing any iSCSI HBA with iscsiadm instead of various vendor
> specific utilities.

agreed

> About the implementation, I think that it's better to have the common
> library code rather than just copying the fs bsg code into iscsi.

Note: I tried to library-ize the transport implementation on the first pass of 
the RFC. But it was making things more complex.  I tried to explain this, 
perhaps not very well (http://marc.info/?l=linux-scsi&m=125725904205688&w=2).

-- james s

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
