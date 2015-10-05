From: Alim Akhtar <alim.akhtar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 13/13] scsi: ufs: Add exynos ufs platform data
Date: Mon, 5 Oct 2015 20:50:10 +0530
Message-ID: <CAGOxZ51BKfh_FyJ9pWv56a0QXUE4Kd3oZM7Ruu6ACg6GsQwyXQ@mail.gmail.com>
References: <201510011845.GN7Kisc4%fengguang.wu@intel.com> <1790578.NZeHVGuJeN@wuerfel>
 <56123165.2060500@samsung.com> <14885029.SsJgQkuPcG@wuerfel> <CAL_JsqJWzqMkkMH8myFX1eeuV-U25Ri_nWhjj2mb3AWh5tzDZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqJWzqMkkMH8myFX1eeuV-U25Ri_nWhjj2mb3AWh5tzDZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Yaniv Gardi <ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James E.J. Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, vinayak holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Amit Kachhap <amit.daniel-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Rob,

On Mon, Oct 5, 2015 at 7:41 PM, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Oct 5, 2015 at 4:06 AM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
>> On Monday 05 October 2015 13:44:29 Alim Akhtar wrote:
>>> CCing Rob Herring,
>>>
>>> Hi Arnd,
>>>
>>> On 10/01/2015 04:59 PM, Arnd Bergmann wrote:
>>> > On Thursday 01 October 2015 18:46:34 kbuild test robot wrote:
>>> >> [auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]
>>> >>
>>> >> config: x86_64-allmodconfig (attached as .config)
>>> >> reproduce:
>>> >>          git checkout 6e153e3bf7c68b019e987c5a0ffadebd9c7d4fbb
>>> >>          # save the attached .config to linux build tree
>>> >>          make ARCH=x86_64
>>> >>
>>> >> All error/warnings (new ones prefixed by >>):
>>> >>
>>> >>>> ERROR: "ufs_hba_exynos_ops" [drivers/scsi/ufs/ufshcd-pltfrm.ko] undefined!
>>> >>
>>> >>
>>> >
>>> > Ah, this seems to be a case of layering violation. It would be best to
>>> > restructure the code so that the exynos driver registers a platform_driver
>>> > by itself for the respective DT compatible string, and then calls
>>> > into the common code from its probe function, rather than having the
>>> > generic driver know about the specific backends.
>>> >
>>> > That approach will also make the generic driver more scalable as we
>>> > add further chip-specific variations, and matches what we do in other
>>> > drivers.
>>> >
>>>
>>> Looks like some discussions on ufs variant driver probe method happened
>>> here [1] few months back.
>>> [1]-> https://lkml.org/lkml/2015/6/3/180
>>
>> Hmm, too bad we didn't catch it then, it's much more work to fix now.
>
> What you suggested is what is being implemented[1]. It is not merged
> yet. The core is a library and the platform specific parts create the
> driver.
>
> Rob
>
> [1] https://lkml.org/lkml/2015/9/2/364

Thanks for the pointer...let me have a look. At least now we have
another variant to test it out.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Alim
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
