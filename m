From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcmu: Fix trailing semicolon
Date: Thu, 18 Jan 2018 01:23:12 -0800
Message-ID: <1516267392.24576.246.camel@haakon3.daterainc.com>
References: <20180116153432.17927-1-luisbg@kernel.org>
         <f188423f-8d53-ffe8-7d85-48424e15411b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <f188423f-8d53-ffe8-7d85-48424e15411b@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: mchristi@redhat.com
Cc: Luis de Bethencourt <luisbg@kernel.org>, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2018-01-16 at 10:25 -0600, Michael Christie wrote:
> On 01/16/2018 09:34 AM, Luis de Bethencourt wrote:
> > The trailing semicolon is an empty statement that does no operation.
> > It is completely stripped out by the compiler. Removing it since it doesn't do
> > anything.
> > 
> > Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
> > ---
> > 
> > Hi,
> > 
> > After fixing the same thing in drivers/staging/rtl8723bs/, Joe Perches
> > suggested I fix it treewide [0].
> > 
> > Best regards 
> > Luis
> > 
> > 
> > [0] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115410.html
> > [1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115390.html
> > 
> >  drivers/target/target_core_user.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 

Applied.  Thanks Luis + MNC.
