From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [RFC v5]update broken web addresses in the kernel.
Date: Tue, 28 Sep 2010 06:41:22 -0700
Message-ID: <4CA1F082.2010900@gmail.com>
References: <1285647599-14719-1-git-send-email-justinmattock@gmail.com>
	<alpine.OSX.2.00.1009281613260.276@localhost>
	<4CA193B6.8020503@gmail.com>
	<alpine.OSX.2.00.1009281713410.276@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <alpine.OSX.2.00.1009281713410.276@localhost>
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
Cc: linux-fbdev@vger.kernel.org, Dimitry Torokhov <dmitry.torokhov@gmail.com>, trivial@kernel.org, Mike Frysinger <vapier.adi@gmail.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Geert Uytterhoeven <geert@linux-m68k.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Matt Turner <mattst88@gmail.com>, alsa-devel@alsa-project.org
List-Id: linux-scsi@vger.kernel.org

On 09/28/2010 12:35 AM, Finn Thain wrote:
>
> On Tue, 28 Sep 2010, Justin P. Mattock wrote:
>
>> o.k... I'll make the changes to the arch patch, and combine the two, and
>> send it to jiri..
>
> Why?
>
> My advice is don't do it unless you want to waste reviewers' time.
>
>> as for the names and signed offs is what is below fine or do I need to
>> change some of them?
>
> If you combine patch 1 and patch 2 and submit that as patch 3, you will
> likely have to CC patch 3 to everyone to whom you sent patch 1 plus
> everyone to whom you sent patch 2. You must also change any "acked-by" to
> "Cc", since patch 3 is new.
>
> Keep the same CC list since Jiri is already on it ("trivial@kernel.org").
>
> Finn
>

alright.. so it will be two patches then..(not the best at the CC etc.. 
thing) cool... and thanks again for reviewing this for me..(back 
breaking work, but somebodies _gots_ to do it..)

Justin P. Mattock
