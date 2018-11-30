From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH RFC 00/15] Zero ****s, hugload of hugs <3
Date: Fri, 30 Nov 2018 20:42:23 +0000
Message-ID: <AEA525BC-406E-4C8C-BD7A-90FB65571255@fb.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
 <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <CAGXu5j+jBNBsD3pvUSfEh6Lc5T1YMpbM0HeG1c6BHiJe+cKVOQ@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Kees Cook <keescook@chromium.org>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>, Geert Uytterhoeven <geert+renesas@glider.be>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, nouveau <nouveau@lists.freedesktop.org>, Amir Goldstein <amir73il@gmail.com>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, Linux mtd <linux-mtd@lists.infradead.org>, "makita.toshiaki@lab.ntt.co.jp" <makita.toshiaki@lab.ntt.co.jp>, "yanjun.zhu@oracle.com" <yanjun.zhu@oracle.com>, Rob Herring <robh@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Helge Deller <deller@gmx.de>, Steven Rostedt <rostedt@goodmis.org>, "federico.vaga@vaga.pv.it" <federico.vaga@vaga.pv.it>, Yonghong Song <yhs@fb.com>, Paolo Abeni <pabeni@redhat.com>Linux Media Mailing List <l>
List-Id: linux-scsi@vger.kernel.org

On 30 Nov 2018, at 14:40, Kees Cook wrote:

> On Fri, Nov 30, 2018 at 11:27 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
>>
>> In order to comply with the CoC, replace **** with a hug.
>
> Heh. I support the replacement of the stronger language, but I find
> "hug", "hugged", and "hugging" to be very weird replacements. Can we
> bikeshed this to "heck", "hecked", and "hecking" (or "heckin" to
> follow true Doggo meme style).
>
> "This API is hugged" doesn't make any sense to me. "This API is
> hecked" is better, or at least funnier (to me). "Hug this interface"
> similarly makes no sense, but "Heck this interface" seems better.
> "Don't touch my hecking code", "What the heck were they thinking?"
> etc... "hug" is odd.
>
> Better yet, since it's only 17 files, how about doing context-specific
> changes? "This API is terrible", "Hateful interface", "Don't touch my
> freakin' code", "What in the world were they thinking?" etc?

I think the bar for changing the documentation/comments should be 
improvement in the clarity or approachability of whatever is being 
changed.

This patch set is kind of like Linus sitting at kernel summit with a 
sign that says "Free Hugs".  Kind of confusing, and really unlikely to 
make anyone involved happier about working on the kernel.

Jarkko, making things clearer and more approachable is absolutely worth 
the time if you're interested, but I think it'll mean larger and more 
individualized changes to these files.

-chris

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
