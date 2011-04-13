From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
 in sysfs
Date: Wed, 13 Apr 2011 11:44:15 -0500
Message-ID: <4DA5D2DF.5080806@cs.wisc.edu>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com> <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com> <4DA52525.3020405@cs.wisc.edu> <4DA5294C.8040305@cs.wisc.edu> <5E4F49720D0BAD499EE1F01232234BA8728A8CB623@AVEXMB1.qlogic.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <open-iscsi+bncCLPJla3WGRDppZftBBoEXTyhaA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA8728A8CB623-HolNjIBXvBOXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Vikas Chaudhary <vikas.chaudhary-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "James.Bottomley-l3A5Bk7waGM@public.gmane.org" <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lalit Chandivade <lalit.chandivade-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Ravi Anand <ravi.anand-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org" <Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 04/13/2011 09:48 AM, Vikas Chaudhary wrote:
>
>
>> -----Original Message-----
>> From: Mike Christie [mailto:michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org]
>> Sent: Wednesday, April 13, 2011 10:11 AM
>> To: Vikas Chaudhary
>> Cc: James.Bottomley-l3A5Bk7waGM@public.gmane.org; linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; open-
>> iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org; Lalit Chandivade; Ravi Anand;
>> Jayamohan.Kallickal-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org
>> Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
>> in sysfs
>>
>> On 04/12/2011 11:23 PM, Mike Christie wrote:
>>> Do we want to make the kernel iscsi iface more generic or maybe just
>>> rename it to reflect it is just based on net settings?
>>>
>>> The issue with making it more generic is that with the current drivers,
>>> we do not care what info like the initiatorname in the kernel code. That
>>> is all handled in userspace because all the session management is there,
>>> so there is no point in adding that complexity here.
>>
>> I take part of this back. We set the iscsi iface name and initiator name
>> on the session right now. We need that info for relogin type of
>> situations where iscsid might have died and we need to know the
>> initiatorname to use. We cannot read it from a disk, because that disk
>> might be the one are are relogging into.
>>
>> It might not hurt to make the kernel's iscsi ifaces abstraction more
>> general.
>
> Yes and also to reflect correct status of network settings it will be
> good to have iscsi_iface in the kernel. This is useful in a case where
> user set DHCP settings then we can reflect IP addresses and other
> settings in the kernel iface.
>

How come you did not export some values like the vlan in the iscsi iface?

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
