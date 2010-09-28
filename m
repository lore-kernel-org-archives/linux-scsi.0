From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [RFC v4]update broken web addresses in the kernel.
Date: Mon, 27 Sep 2010 19:07:50 -0700
Message-ID: <4CA14DF6.3070505@gmail.com>
References: <1285525875-9920-1-git-send-email-justinmattock@gmail.com>
	<20100927151005.GC11086@tuxdriver.com>
	<1285603383.1732.106.camel@Joe-Laptop> <4CA0CB0F.3060303@gmail.com>
	<alpine.OSX.2.00.1009281119570.276@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <alpine.OSX.2.00.1009281119570.276@localhost>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
	<mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
	<mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Sender: alsa-devel-bounces@alsa-project.org
Errors-To: alsa-devel-bounces@alsa-project.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linux-fbdev@vger.kernel.org, Dimitry Torokhov <dmitry.torokhov@gmail.com>, trivial@kernel.org, Mike Frysinger <vapier.adi@gmail.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Geert Uytterhoeven <geert@linux-m68k.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Joe Perches <joe@perches.com>, Matt Turner <mattst88@gmail.com>, alsa-devel@alsa-project.org
List-Id: linux-scsi@vger.kernel.org

On 09/27/2010 06:37 PM, Finn Thain wrote:
>
> On Mon, 27 Sep 2010, Justin P. Mattock wrote:
>
>> On 09/27/2010 09:03 AM, Joe Perches wrote:
>>> On Mon, 2010-09-27 at 11:10 -0400, John W. Linville wrote:
>>>> On Sun, Sep 26, 2010 at 11:31:15AM -0700, Justin P. Mattock wrote:
>>>>> Below is an updated patch from the original fixing broken web
>>>>> addresses in the kernel. Thanks for all the help and info on this
>>>>> to everybody.. Hopefully I didnt miss any of them(if so let me
>>>>> know, and I'll resend).
>>>> Changing a URL for a relocated page is one thing, but removing links
>>>> isn't necessarily a great idea.  Even if the site is technically
>>>> gone, it may be possible to find information e.g through the
>>>> Internet Archive Wayback Machine.
>>>
>>> Perhaps it'd be better to scrape the contents of the various web
>>> pages, collect them somewhere like wiki.kernel.org and encourage
>>> others to put new contributions in that site.
>
> The copyright problem aside, this might be a good idea for material not
> already archived but I don't think it makes sense to start a new
> archive when archive.org (or other) has the information.
>
> And which version(s) do you scrape? I discussed some problems with
> changing URLs in another thread: http://lkml.org/lkml/2010/9/22/22
>
> Anyway, without knowing what future archive(s) would be available or
> relevant to any given URL in the future, I think the best we might do is a
> "Retrieved on YYYY-MM-DD" qualification for new URLs.
>
>>
>>
>> yeah I think somebody was saying something about having a separate file,
>> with all the web addresses in them or something...In any case, up to you
>> guys..
>
> I don't see how moving the addresses would help.
> And would it not make the information harder to find?
>
> Finn
>

depends on how the setup is.. I was thinking of having some kind of 
letter/number scheme i.e. (A-13) in the comment, then in the file with 
all the addresses under article "A" 13th address down you would have the 
web address.(but keep in mind that's just speculation..)

Justin P. Mattock
