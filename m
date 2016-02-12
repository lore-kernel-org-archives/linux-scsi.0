From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 3/3] add support for DWC UFS Host Controller
Date: Fri, 12 Feb 2016 13:36:39 -0600
Message-ID: <CAL_JsqJ53VgyoJiLi-gYyd5F=7THaWAY0RG2+FO_Md8TzrSCMA@mail.gmail.com>
References: <cover.1455192008.git.jpinto@synopsys.com> <ee97e9b0ece0d819debe403c752d233c6267e02e.1455192008.git.jpinto@synopsys.com>
 <20160212163636.GA31045@rob-hp-laptop> <56BE1BC8.5020604@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BE1BC8.5020604-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: vinayak holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 12, 2016 at 11:52 AM, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org> wrote:
> Hi Rob,
>
> On 2/12/2016 4:36 PM, Rob Herring wrote:
>> On Thu, Feb 11, 2016 at 12:13:06PM +0000, Joao Pinto wrote:
>>> +Required properties:
>>> +- compatible        : compatible string ("snps,ufshcd-1.0", "snps,ufshcd-1.1"
>>> +  or "snps,ufshcd-2.0")
>>
>> History has taught us this needs to have a vendor specific compatible
>> string as well. Don't necessarily have to define it now, but just state
>> a vendor string is needed too.
>
> The compatibility string already as the "snps" which is the acronym for Synopsys
> which is the HW Controller vendor. Isn't this enough?

Go look drivers for any licensed IP: DW PCIe, DW GMAC, USB EHCI
controllers (pretty much all licensed IP), etc. They all have
variations either from versions of the IP, configuration of the IP,
"enhancements" by the licensee, integration quirks, or all of the
above.

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
