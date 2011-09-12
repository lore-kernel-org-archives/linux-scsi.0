From: James Cloos <cloos@jhcloos.com>
Subject: Re: found __[us]{8,16,32,64} type without #include <linux/types.h>
Date: Mon, 12 Sep 2011 11:27:03 -0400
Message-ID: <m3zki9wzkw.fsf@jhcloos.com>
References: <m3vct1u75k.fsf@jhcloos.com> <201109091629.52879.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dri-devel-bounces+sf-dri-devel=m.gmane.org@lists.freedesktop.org>
In-Reply-To: <201109091629.52879.arnd@arndb.de> (Arnd Bergmann's message of
	"Fri, 9 Sep 2011 16:29:52 +0200")
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
	<mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
	<mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Sender: dri-devel-bounces+sf-dri-devel=m.gmane.org@lists.freedesktop.org
Errors-To: dri-devel-bounces+sf-dri-devel=m.gmane.org@lists.freedesktop.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "AB" == Arnd Bergmann <arnd@arndb.de> writes:

AB> The script only checks for direct inclusions of types.h, while the
AB> drm headers get it from drm.h.

I see.  It had been quite some time since I last did a make 1>/dev/null,
long enough that I hadn't noticed that message before.

It is good to know that it is a false positive.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
