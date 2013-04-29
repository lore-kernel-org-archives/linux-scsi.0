From: Masanori Goto <gotom@sanori.org>
Subject: Re: [PATCH 10/21] [SCSI] nsp32: use mdelay instead of large udelay
 constants
Date: Tue, 30 Apr 2013 06:41:38 +0900
Message-ID: <CALZLnaEbXRJY2qntWucm00mNq78CRD8Vhp7KoTw6Me0frxtaDw@mail.gmail.com>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
 <1366910944-3033663-11-git-send-email-arnd@arndb.de>
 <CALZLnaFeLcaGM7_McTZ=pKBRnpXk0AvqOTF=1YCqJv-53yk4XQ@mail.gmail.com>
 <201304291521.14195.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <201304291521.14195.arnd@arndb.de>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Oops, you're absolutely correct.  Thanks for the follow up!  Please
change it as follow as you mentioned:

Acked-by: GOTO Masanori <gotom@debian.or.jp>

Best regrads,
-- gotom

2013/4/29 Arnd Bergmann <arnd@arndb.de>:
> On Friday 26 April 2013, Masanori Goto wrote:
>> 2013/4/25 Arnd Bergmann <arnd@arndb.de>
>> >
>> > ARM cannot handle udelay for more than 2 miliseconds, so we
>> > should use mdelay instead for those.
>> >
>>
>> Singed-off-by: GOTO Masanori <gotom@debian.or.jp>
>
> Thanks. I assume you mean "Acked-by", not "Singed-off" as in "burnt"
> or "Signed-off" as a notification that you have applied it to your
> own git tree.
>
> I'll keep the patch with an your "Acked-by" line in my tree unless
> James wants to apply to the scsi tree.
>
>         Arnd
>
