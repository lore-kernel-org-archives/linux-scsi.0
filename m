From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v13 0/9] add support for DWC UFS Controller
Date: Tue, 5 Apr 2016 11:27:18 +0100
Message-ID: <57039306.4090704@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
 <yq1inzxeyoe.fsf@sermon.lab.mkp.net> <570380B9.30800@synopsys.com>
 <5B8DA87D05A7694D9FA63FD143655C1B541E3FE8@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B541E3FE8-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org" <CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "mark.rutland-5wv7dgnIgG8@public.gmane.org" <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 4/5/2016 11:15 AM, Winkler, Tomas wrote:
> 
> Hi,
> 
> On 4/5/2016 12:34 AM, Martin K. Petersen wrote:
>>>>>>> "Joao" == Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org> writes:
>>
>> Joao,
>>
>> Joao> The work consisted of: - Fixed typo in ufshcd-pltfrm.c - Tweak 
>> Joao> ufshcd.c for UFS 2.0 support - Implement ufshcd-dwc which 
>> Joao> contains all DWC HW specific code - Unipro attributes were added 
>> Joao> and new registers were added to the driver - Implement a 
>> Joao> tc-dwc-g210 containing G210 MPHY specific code - Implement a 
>> Joao> tc-dwc-g210 glue platform driver - Implement a tc-dwc-g210 glue 
>> Joao> pci driver - Documentation update
>>
>> You really need to keep track of which Acked-by: and Reviewed-by: tags 
>> you have gotten from people and apply them to patches that you haven't 
>> changed. Otherwise we start from scratch every time you resubmit.
>>
>> Thanks!
>>
> 
> It's ok to submit the same v13 with the ACK tags?
> 
> You can add my Ack on the core patches, not DWC specific, I didn't really look at those properly.
> Thanks
> Tomas 

Nice! Going to send a new v13 with your acks.

> 

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
